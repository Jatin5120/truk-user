import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trukapp/helper/helper.dart';
import 'package:trukapp/helper/payment_type.dart';
import 'package:trukapp/models/coupon_model.dart';
import 'package:trukapp/models/notification_model.dart';
import 'package:trukapp/models/pending_payout_model.dart';
import 'package:trukapp/models/quote_model.dart';
import '../models/material_model.dart';
import '../models/user_model.dart';
import '../sessionmanagement/session_manager.dart';

class FirebaseHelper {
  static const String walletCollection = 'Wallet';
  static const String walletTranscationCollection = 'WalletTransaction';
  static const String userCollection = 'Users';
  static const String transactionCollection = 'Transaction';
  static const String requestCollection = 'Request';
  static const String quoteCollection = 'Quote';
  static const String driverCollection = 'Drivers';
  static const String fleetOwnerCollection = 'FleetOwners';
  static const String chatListCollection = 'ChatList';
  static const String chatCollection = 'Chats';
  static const String shipmentCollection = 'Shipment';
  static const String notificationCollection = "Notifications";
  static const String payoutCollection = "PendingPayout";
  static const String couponCollection = "Coupons";
  static const String couponUsageCollection = "CouponUsage";
  static const String insuranceCollection = "Insurance";
  static const String invoiceCollection = "invoice";

  static FirebaseAuth _auth = FirebaseAuth.instance;
  User user = _auth.currentUser;
  Future<UserModel> getCurrentUser({String uid}) async {
    String u = uid;
    if (uid == null) {
      u = user.uid;
    }

    CollectionReference reference = FirebaseFirestore.instance.collection(userCollection);

    final d = await reference.doc(u).get();
    if (d.exists) {
      return UserModel.fromSnapshot(d);
    }
    return null;
  }

  Future insertUser(
    String uid,
    String name,
    String email,
    String mobile,
    String company,
    String city,
    String state, {
    String gst = "NA",
  }) async {
    int joiningTime = DateTime.now().millisecondsSinceEpoch;
    CollectionReference reference = FirebaseFirestore.instance.collection(userCollection);
    Map<String, dynamic> userData = {
      'uid': uid,
      'name': name,
      'email': email,
      'mobile': mobile,
      'company': company,
      'city': city,
      'state': state,
      'joining': joiningTime
    };
    await reference.doc(uid).set(userData);
    await SharedPref().createSession(uid, name, email, mobile);
  }

  Future<void> updateUser({String name, String email, String company}) async {
    CollectionReference reference = FirebaseFirestore.instance.collection(userCollection);
    Map<String, dynamic> userData = {
      'uid': user.uid,
      'name': name,
      'email': email,
      'company': company,
    };
    await reference.doc(user.uid).update(userData);
  }

  Future<String> insertRequest({
    @required String pickupDate,
    @required List<MaterialModel> materials,
    @required LatLng source,
    @required LatLng destination,
    @required String trukType,
    @required String loadType,
    @required String mandateType,
    @required bool isInsured,
    @required String truckModel,
  }) async {
    User user = FirebaseAuth.instance.currentUser;
    String phoneNumber = user.phoneNumber;
    String uid = user.uid;
    final int bookingDate = DateTime.now().millisecondsSinceEpoch;
    CollectionReference reference = FirebaseFirestore.instance.collection(requestCollection);
    List<Map<String, dynamic>> materialMap = [];
    for (MaterialModel m in materials) {
      materialMap.add(m.toMap());
    }
    var sourceString = await Helper().setLocationText(source);
    var destinationString = await Helper().setLocationText(destination);

    await reference.add({
      'bookingId': bookingDate,
      'uid': uid,
      'bookingDate': bookingDate,
      'mobile': phoneNumber,
      'materials': materialMap,
      'pickupDate': pickupDate,
      'source': "${source.latitude},${source.longitude}",
      'destination': "${destination.latitude},${destination.longitude}",
      'insured': isInsured,
      'mandate': mandateType,
      'load': loadType,
      'truk': trukType,
      'sourceString': sourceString,
    'destinationString': destinationString,
      'truckModel':truckModel
    });
    return bookingDate.toString();
  }

  Future updateQuoteStatus(String id, String status, {String paymentStatus = PaymentType.cod}) async {
    CollectionReference reference = FirebaseFirestore.instance.collection(quoteCollection);
    await reference.doc(id).update({
      'status': status,
      'paymentStatus': paymentStatus,
    });
  }

  Future deleteRequest(String id) async {
    CollectionReference reference = FirebaseFirestore.instance.collection(requestCollection);
    await reference.doc(id).delete();
  }

  Future<void> updateWallet(String tid, double amount, int type) async {
    //type is  0 = debit and 1 = credit

    final currentTimeMilli = DateTime.now().millisecondsSinceEpoch;
    CollectionReference reference = FirebaseFirestore.instance.collection(walletCollection);
    final snapWallet = await reference.doc(user.uid).get();
    await transaction(tid, amount, type, currentTimeMilli, walletTranscationCollection);
    await transaction(tid, amount, type, currentTimeMilli, transactionCollection);
    if (snapWallet.exists) {
      double amt = type == 1 ? snapWallet.get("amount") + amount : snapWallet.get("amount") - amount;
      reference.doc(user.uid).update({
        'amount': amt,
        'lastUpdate': currentTimeMilli,
      });
    } else {
      await reference.doc(user.uid).set({
        'amount': type == 1 ? amount : -amount,
        'lastUpdate': currentTimeMilli,
      });
    }
  }

  //final String  uid = FirebaseHelper().user.uid;
  Future transaction(String transactionId, double amount, int type, int time, String collection,
      {String note = 'truk money'}) async {
    //type is  0 = debit and 1 = credit

    CollectionReference reference = FirebaseFirestore.instance.collection(collection);

    await reference.add({
      'tid': transactionId,
      'amount': amount,
      'type': type == 1 ? "Credit" : "Debit",
      'uid': user.uid,
      'time': time,
      'note': note
    });
  }

  Future insertPayout({int bookingId, double amount, String status, String agent, int time}) async {
    CollectionReference reference = FirebaseFirestore.instance.collection(payoutCollection);
    PendingPayoutModel model =
        PendingPayoutModel(agent: agent, amount: amount, bookingId: bookingId, time: time, uid: user.uid);
    await reference.add(model.toMap());
  }

  StreamSubscription getNotificationCount() {
    CollectionReference ref = FirebaseFirestore.instance.collection(FirebaseHelper.notificationCollection);
    final stream = ref.where('uid', isEqualTo: user.uid).snapshots();

    StreamSubscription s = stream.listen((element) {});
    return s;
  }

  Future<String> getCommonInsurance() async{
    final ref = await FirebaseFirestore.instance.collection(FirebaseHelper.insuranceCollection).doc('common').get();
    var data = ref.get('insurance');
    return data;
  }

  Future<String> getCompanyInsurance() async{
    final ref = await FirebaseFirestore.instance.collection(FirebaseHelper.insuranceCollection).doc('truk_company').get();
    var data = ref.get('insurance');
    return data;
  }

  Future seenNotification(List<NotificationModel> notifications) async {
    CollectionReference ref = FirebaseFirestore.instance.collection(FirebaseHelper.notificationCollection);
    for (NotificationModel m in notifications) {
      await ref.doc(m.id).update({
        'isSeen': true,
      });
    }
  }

  Future<CouponModel> validateCoupon(String coupon) async {
    CollectionReference reference = FirebaseFirestore.instance.collection(FirebaseHelper.couponCollection);
    final d = await reference.where('code', isEqualTo: coupon.toUpperCase()).snapshots().first;
    if (d.docs.length <= 0) {
      return null;
    }
    CouponModel c = CouponModel.fromSnap(d.docs[0]);
    print(c.minimum);
    return c;
  }

  Future<bool> checkCouponUsage(String coupon) async {
    CollectionReference reference = FirebaseFirestore.instance.collection(FirebaseHelper.couponUsageCollection);
    final d = await reference
        .where('uid', isEqualTo: user.uid)
        .where('code', isEqualTo: coupon.toUpperCase())
        .snapshots()
        .first;
    if (d.docs.length <= 0) {
      return false;
    }
    return true;
  }

  Future<void> insertCouponUsage({QuoteModel quoteModel, String coupon, double discountPrice}) async {
    CollectionReference reference = FirebaseFirestore.instance.collection(FirebaseHelper.couponUsageCollection);
    await reference.add({
      'code': coupon,
      'bookingId': quoteModel.bookingId,
      'price': double.parse(quoteModel.price),
      'discountPrice': discountPrice,
      'uid': user.uid,
    });
  }
}
