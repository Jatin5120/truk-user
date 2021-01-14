import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/firebase_helper/firebase_helper.dart';
import 'package:trukapp/models/chatting_list_model.dart';
import 'package:trukapp/models/quote_model.dart';
import 'package:trukapp/models/user_model.dart';

class ChatController with ChangeNotifier {
  final User user = FirebaseAuth.instance.currentUser;
  List<ChattingListModel> chatList = [];
  List<ChattingListModel> get chattings => chatList;
  bool isChatLoading = true;
  getAllMessages() async {
    isChatLoading = true;
    CollectionReference userRef = FirebaseFirestore.instance.collection(FirebaseHelper.fleetOwnerCollection);
    Stream<QuerySnapshot> snap = FirebaseFirestore.instance
        .collection(FirebaseHelper.userCollection)
        .doc(user.uid)
        .collection(FirebaseHelper.chatListCollection)
        .orderBy('time', descending: true)
        .snapshots();

    snap.listen((event) async {
      chatList = [];
      if (event.size > 0) {
        for (QueryDocumentSnapshot snapshot in event.docs) {
          String otherUser = snapshot.get('clientId');
          int bookingId = snapshot.get('bookingId');
          final doc = await userRef.doc(otherUser).get();
          UserModel userModel = UserModel.fromSnapshot(doc);
          final bookingSnap = await FirebaseFirestore.instance
              .collection(FirebaseHelper.quoteCollection)
              .where('bookingId', isEqualTo: bookingId)
              .snapshots()
              .first;

          final bookingDoc = QuoteModel.fromSnapshot(bookingSnap.docs[0]);
          chatList.add(ChattingListModel(id: snapshot.id, quoteModel: bookingDoc, userModel: userModel));
        }
      }
      isChatLoading = false;
      notifyListeners();
    });
  }
}
