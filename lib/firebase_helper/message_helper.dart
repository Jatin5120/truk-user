import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trukapp/firebase_helper/firebase_helper.dart';
import 'package:trukapp/models/chatting_list_model.dart';
import 'package:trukapp/models/chatting_model.dart';

class MessageHelper {
  final User user = FirebaseAuth.instance.currentUser;
  sendMessage(String message, String receiver, int bookingId) async {
    final int currentTime = DateTime.now().millisecondsSinceEpoch;
    ChattingModel model = ChattingModel(
        bookingId: bookingId, isSeen: false, message: message, receiver: receiver, sender: user.uid, time: currentTime);

    updateChatList(user.uid, false, currentTime, bookingId, receiver);
    updateChatList(receiver, true, currentTime, bookingId, receiver);

    CollectionReference reference = FirebaseFirestore.instance.collection(FirebaseHelper.chatCollection);
    await reference.add(model.toMap());
  }

  updateChatList(String id, bool isVendor, int time, int bookingId, String receiver) async {
    CollectionReference referenceChatList = FirebaseFirestore.instance
        .collection(isVendor ? FirebaseHelper.fleetOwnerCollection : FirebaseHelper.userCollection)
        .doc(id)
        .collection(FirebaseHelper.chatListCollection);

    ChattingListModel listModel = ChattingListModel(
      bookingId: bookingId,
      id: "$receiver$bookingId",
      time: time,
      vendorId: receiver,
    );

    await referenceChatList.doc("$receiver$bookingId").set(listModel.toMap());
  }
}
