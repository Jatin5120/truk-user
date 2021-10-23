import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CancelModal {
  final String bookingId;
  final String uid;
  final String cancelledby;
  final String agent;
  final double amount;
  final String reason;
  final int time;
  CancelModal({
    @required this.bookingId,
    @required this.uid,
    @required this.cancelledby,
    @required this.agent,
    @required this.amount,
    @required this.reason,
    @required this.time,
  });

  CancelModal copyWith({
    String bookingId,
    String uid,
    String cancelledby,
    String agent,
    double amount,
    String reason,
    int time,
  }) {
    return CancelModal(
      bookingId: bookingId ?? this.bookingId,
      uid: uid ?? this.uid,
      cancelledby: cancelledby ?? this.cancelledby,
      agent: agent ?? this.agent,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'uid': uid,
      'cancelledby': cancelledby,
      'agent': agent,
      'amount': amount,
      'reason': reason,
      'time': time,
    };
  }

  factory CancelModal.fromMap(Map<String, dynamic> map) {
    return CancelModal(
      bookingId: map['bookingId'],
      uid: map['uid'],
      cancelledby: map['cancelledby'],
      agent: map['agent'],
      amount: map['amount'],
      reason: map['reason'],
      time: map['time'],
    );
  }
  factory CancelModal.fromSnap(QueryDocumentSnapshot map) {
    return CancelModal(
      bookingId: map.get('bookingId'),
      uid: map.get('uid'),
      cancelledby: map.get('cancelledby'),
      agent: map.get('agent'),
      amount: map.get('amount'),
      reason: map.get('reason'),
      time: map.get('time'),
    );
  }

  String toJson() => json.encode(toMap());

  factory CancelModal.fromJson(String source) =>
      CancelModal.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CancelModel(bookingId: $bookingId, uid: $uid, cancelledby: $cancelledby, agent: $agent, amount: $amount, reason: $reason, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CancelModal &&
        other.bookingId == bookingId &&
        other.uid == uid &&
        other.cancelledby == cancelledby &&
        other.agent == agent &&
        other.amount == amount &&
        other.reason == reason &&
        other.time == time;
  }

  @override
  int get hashCode {
    return bookingId.hashCode ^
        uid.hashCode ^
        cancelledby.hashCode ^
        agent.hashCode ^
        amount.hashCode ^
        reason.hashCode ^
        time.hashCode;
  }
}
