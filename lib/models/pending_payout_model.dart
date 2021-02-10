import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PendingPayoutModel {
  String uid;
  String agent;
  int bookingId;
  double amount;
  String status;
  int time;
  PendingPayoutModel({
    this.uid,
    this.agent,
    this.bookingId,
    this.amount,
    this.status,
    this.time,
  });

  PendingPayoutModel copyWith({
    String uid,
    String agent,
    int bookingId,
    double amount,
    String status,
    int time,
  }) {
    return PendingPayoutModel(
      uid: uid ?? this.uid,
      agent: agent ?? this.agent,
      bookingId: bookingId ?? this.bookingId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'agent': agent,
      'bookingId': bookingId,
      'amount': amount,
      'status': status,
      'time': time,
    };
  }

  factory PendingPayoutModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return PendingPayoutModel(
      uid: map['uid'],
      agent: map['agent'],
      bookingId: map['bookingId'],
      amount: map['amount'],
      status: map['status'],
      time: map['time'],
    );
  }

  factory PendingPayoutModel.fromSnap(QueryDocumentSnapshot map) {
    if (map == null) return null;

    return PendingPayoutModel(
      uid: map.get('uid'),
      agent: map.get('agent'),
      bookingId: map.get('bookingId'),
      amount: map.get('amount'),
      status: map.get('status'),
      time: map.get('time'),
    );
  }
}
