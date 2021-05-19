import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../firebase_helper/firebase_helper.dart';

class UserModel {
  String uid;
  String name;
  String mobile;
  String email;
  String city;
  String state;
  String company;
  int joining;
  String token;
  String image;
  bool notification;
  String gst;
  UserModel({
    this.uid,
    this.name,
    this.mobile,
    this.email,
    this.city,
    this.state,
    this.company,
    this.joining,
    this.token,
    this.image,
    this.notification,
    this.gst = "NA",
  });

  UserModel copyWith({
    String uid,
    String name,
    String mobile,
    String email,
    String city,
    String state,
    String company,
    int joining,
    String token,
    String image,
    bool notification,
    String gst,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      city: city ?? this.city,
      state: state ?? this.state,
      company: company ?? this.company,
      joining: joining ?? this.joining,
      token: token ?? this.token,
      image: image ?? this.image,
      notification: notification ?? this.notification,
      gst: gst ?? this.gst,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'mobile': mobile,
      'email': email,
      'city': city,
      'state': state,
      'company': company,
      'joining': joining,
      'token': token,
      'image': image ?? 'na',
      'notification': notification ?? true,
      'gst': gst ?? "NA",
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserModel(
      uid: map['uid'],
      name: map['name'],
      mobile: map['mobile'],
      email: map['email'],
      city: map['city'],
      state: map['state'],
      company: map['company'],
      token: map['token'],
      joining: map['joining'],
      image: map['image'] ?? 'na',
      notification: map['notification'] ?? true,
      gst: map['gst'] ?? "NA",
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot map) {
    if (map == null) return null;

    return UserModel(
      uid: map.get('uid'),
      name: map.get('name'),
      mobile: map.get('mobile'),
      email: map.get('email'),
      city: map.get('city'),
      state: map.get('state'),
      company: map.get('company'),
      joining: map.get('joining'),
      token: map.data().containsKey('token') ? map.get('token') : 'token',
      image: map.data().containsKey('image') ? map.get('image') : 'na',
      notification: map.data().containsKey('notification') ? map.get('notification') : true,
      gst: map.data().containsKey('gst') ? map.get('gst') : "NA",
    );
  }
}

class MyUser with ChangeNotifier {
  UserModel userModel;
  bool isUserLoading = true;
  final User currentUser = FirebaseAuth.instance.currentUser;
  UserModel get user => userModel;
  StreamSubscription<DocumentSnapshot> streamSubscription;
  getUserFromDatabase() async {
    isUserLoading = true;

    CollectionReference reference = FirebaseFirestore.instance.collection(FirebaseHelper.userCollection);
    final d = reference.doc(currentUser.uid).snapshots();
    streamSubscription = d.listen((element) {
      if (element.exists) {
        userModel = UserModel.fromSnapshot(element);
      }
      isUserLoading = false;
      notifyListeners();
    });
  }

  updateNotification(bool status) async {
    CollectionReference reference = FirebaseFirestore.instance.collection(FirebaseHelper.userCollection);
    await reference.doc(currentUser.uid).update({
      "notification": status,
    });
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    if (streamSubscription != null) streamSubscription.cancel();
  }
}
