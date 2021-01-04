import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trukapp/firebase_helper/firebase_helper.dart';
import 'package:trukapp/models/chatting_list_model.dart';
import 'package:trukapp/utils/constants.dart';
import '../screens/support.dart';
import '../utils/no_data_page.dart';

class SupportTicketScreen extends StatefulWidget {
  @override
  _SupportTicketScreenState createState() => _SupportTicketScreenState();
}

class _SupportTicketScreenState extends State<SupportTicketScreen> {
  final User user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    //Provider.of<MyChattingList>(context, listen: false).getAllChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Support Tickets'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(FirebaseHelper.userCollection)
              .doc(user.uid)
              .collection(FirebaseHelper.chatListCollection)
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            }
            if (snapshot.hasError) {
              return NoDataPage(
                text: 'Error',
              );
            }

            return buildChatList(snapshot.data.docs);
          }),
    );
  }

  Widget buildChatList(List<QueryDocumentSnapshot> docss) {
    return docss.length <= 0
        ? NoDataPage(
            text: 'No Support Tickets',
          )
        : ListView.builder(
            itemCount: docss.length,
            itemBuilder: (context, index) {
              ChattingListModel model = ChattingListModel.fromSnap(docss[index]);
              return Container(
                height: 20,
                color: Colors.red,
                child: Text(model.id),
              );
            },
          );
  }
}
