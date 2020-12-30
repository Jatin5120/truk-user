import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:trukapp/firebase_helper/firebase_helper.dart';

class ChattingListModel {
  String id;
  int bookingId;
  String vendorId;
  int time;
  ChattingListModel({
    this.id,
    this.bookingId,
    this.vendorId,
    this.time,
  });

  ChattingListModel copyWith({
    String id,
    int bookingId,
    String vendorId,
    int time,
  }) {
    return ChattingListModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      vendorId: vendorId ?? this.vendorId,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'vendorId': vendorId,
      'time': time,
    };
  }

  factory ChattingListModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ChattingListModel(
      id: map['id'],
      bookingId: map['bookingId'],
      vendorId: map['vendorId'],
      time: map['time'],
    );
  }

  factory ChattingListModel.fromSnap(QueryDocumentSnapshot snap) {
    if (snap == null) return null;

    return ChattingListModel(
      id: snap.get('id'),
      bookingId: snap.get('bookingId'),
      vendorId: snap.get('vendorId'),
      time: snap.get('time'),
    );
  }
}
