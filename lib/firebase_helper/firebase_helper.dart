import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/material_model.dart';
import '../models/user_model.dart';
import '../sessionmanagement/session_manager.dart';

class FirebaseHelper {
  static final String walletCollection = 'Wallet';
  static final String walletTranscationCollection = 'WalletTransaction';
  static final String userCollection = 'Users';
  static final String transactionCollection = 'Transaction';
  static final String requestCollection = 'Request';
  static final String quoteCollection = 'Quote';
  static final String driverCollection = 'Drivers';
  static final String fleetOwnerCollection = 'FleetOwners';
  static final String chatListCollection = 'ChatList';
  static final String chatCollection = 'Chats';

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
      String uid, String name, String email, String mobile, String company, String city, String state) async {
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
  }) async {
    User user = FirebaseAuth.instance.currentUser;
    String phoneNumber = user.phoneNumber;
    String uid = user.uid;
    final int bookingDate = DateTime.now().millisecondsSinceEpoch;
    CollectionReference reference = FirebaseFirestore.instance.collection("Request");
    List<Map<String, dynamic>> materialMap = [];
    for (MaterialModel m in materials) {
      materialMap.add(m.toMap());
    }
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
    });
    return bookingDate.toString();
  }

  Future updateQuoteStatus(String id, String status) async {
    CollectionReference reference = FirebaseFirestore.instance.collection(quoteCollection);
    await reference.doc(id).update({
      'status': status,
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
        'amount': amount,
        'lastUpdate': currentTimeMilli,
      });
    }
  }

  Future transaction(String transactionId, double amount, int type, int time, String collection) async {
    //type is  0 = debit and 1 = credit

    CollectionReference reference = FirebaseFirestore.instance.collection(collection);

    await reference.add({
      'tid': transactionId,
      'amount': amount,
      'type': type == 1 ? "Credit" : "Debit",
      'uid': user.uid,
      'time': time,
    });
  }
}
