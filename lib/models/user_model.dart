import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:trukapp/firebase_helper/firebase_helper.dart';

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
  UserModel(
<<<<<<< HEAD
      {this.uid, this.name, this.mobile, this.email, this.city, this.state, this.company, this.joining, this.token});
=======
      {this.uid,
      this.name,
      this.mobile,
      this.email,
      this.city,
      this.state,
      this.company,
      this.joining});
>>>>>>> f75a1563b070b19f0d13e53444df121fb504e393

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
        token: token ?? this.token);
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
      'token': token
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
        joining: map['joining']);
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
        token: map.get('token'));
  }
}

class MyUser with ChangeNotifier {
  UserModel userModel;
  bool isUserLoading = true;

  UserModel get user => userModel;

  getUserFromDatabase() async {
    isUserLoading = true;
    userModel = await FirebaseHelper().getCurrentUser();
    isUserLoading = false;
    notifyListeners();
  }
}
