import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String uid;
  String message;
  int time;
  bool isVendor;
  bool isDriver;
  NotificationModel({
    this.uid,
    this.message,
    this.time,
    this.isVendor,
    this.isDriver,
  });

  NotificationModel copyWith({
    String uid,
    String message,
    int time,
    bool isVendor,
    bool isDriver,
  }) {
    return NotificationModel(
      uid: uid ?? this.uid,
      message: message ?? this.message,
      time: time ?? this.time,
      isVendor: isVendor ?? this.isVendor,
      isDriver: isDriver ?? this.isDriver,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'msg': message,
      'time': time,
      'isVendor': isVendor,
      'isDriver': isDriver,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return NotificationModel(
      uid: map['uid'],
      message: map['msg'],
      time: map['time'],
      isVendor: map['isVendor'],
      isDriver: map['isDriver'],
    );
  }
  factory NotificationModel.fromSnap(QueryDocumentSnapshot snap) {
    if (snap == null) return null;

    return NotificationModel(
      uid: snap.get('uid'),
      message: snap.get('msg'),
      time: snap.get('time'),
      isVendor: snap.get('isVendor'),
      isDriver: snap.get('isDriver'),
    );
  }
}
