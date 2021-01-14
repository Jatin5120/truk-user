import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trukapp/helper/helper.dart';
import 'package:trukapp/models/chat_controller.dart';
import '../firebase_helper/firebase_helper.dart';
import '../models/chatting_list_model.dart';
import '../utils/chat_list_row.dart';
import '../utils/constants.dart';
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
    Size size = MediaQuery.of(context).size;
    final pChatList = Provider.of<ChatController>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Support Tickets'),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: pChatList.isChatLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              )
            : (pChatList.chattings.length <= 0
                ? NoDataPage(
                    text: 'No Support Chat',
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: pChatList.chattings.length,
                    itemBuilder: (context, index) {
                      final ChattingListModel chattingListModel = pChatList.chattings[index];
                      return messageTile(chattingListModel);
                    },
                  )),
      ),
    );
  }

  Widget messageTile(ChattingListModel chattingListModel) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => Support(
              chatListModel: chattingListModel,
            ),
          ),
        );
      },
      child: Card(
        elevation: 3.5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundColor: Colors.grey, foregroundColor: Colors.white, child: Icon(Icons.account_circle)),
              SizedBox(
                width: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chattingListModel.userModel.name.toUpperCase(),
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        FutureBuilder<String>(
                          future: Helper().setLocationText(chattingListModel.quoteModel.source),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data.split(",")[1],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            );
                          },
                        ),
                        Text("-"),
                        FutureBuilder<String>(
                          future: Helper().setLocationText(chattingListModel.quoteModel.destination),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data.split(",")[1],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        child: Text(
                          chattingListModel.quoteModel.pickupDate,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        chattingListModel.quoteModel.trukName,
                        style: TextStyle(color: primaryColor, fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
