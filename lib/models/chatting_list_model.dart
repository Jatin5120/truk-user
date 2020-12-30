import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

class MyChattingList with ChangeNotifier {
  final User user = FirebaseAuth.instance.currentUser;
  bool isChatListLoading = true;
  List<ChattingListModel> chatList = [];
  List<ChattingListModel> get chats => chatList;
  getAllChats() async {
    isChatListLoading = true;
    Stream<QuerySnapshot> snap = FirebaseFirestore.instance
        .collection(FirebaseHelper.userCollection)
        .doc(user.uid)
        .collection(FirebaseHelper.chatListCollection)
        .orderBy('time', descending: true)
        .snapshots();
    List<QueryDocumentSnapshot> d = [];
    await snap.forEach((element) {
      d.addAll(element.docs);
    });
    if (d.length <= 0) {
      chatList = [];
    } else {
      d.forEach((element) {
        chatList.add(ChattingListModel.fromSnap(element));
      });
    }
    notifyListeners();
  }
}
