import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trukapp/models/material_model.dart';
import 'package:trukapp/models/user_model.dart';
import 'package:trukapp/sessionmanagement/session_manager.dart';

class FirebaseHelper {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> getCurrentUser({String uid}) async {
    String u = uid;
    if (uid == null) {
      User user = _auth.currentUser;
      u = user.uid;
    }

    CollectionReference reference = FirebaseFirestore.instance.collection("Users");

    final d = await reference.doc(u).get();
    if (d.exists) {
      return UserModel.fromSnapshot(d);
    }
    return null;
  }

  Future insertUser(
      String uid, String name, String email, String mobile, String company, String city, String state) async {
    int joiningTime = DateTime.now().millisecondsSinceEpoch;
    CollectionReference reference = FirebaseFirestore.instance.collection("Users");
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
    CollectionReference reference = FirebaseFirestore.instance.collection('Quote');
    await reference.doc(id).update({
      'status': status,
    });
  }
}
