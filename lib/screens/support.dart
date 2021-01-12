import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../firebase_helper/firebase_helper.dart';
import '../firebase_helper/message_helper.dart';
import '../helper/helper.dart';
import '../models/chatting_list_model.dart';
import '../models/chatting_model.dart';
import '../utils/chat_list_row.dart';
import '../utils/no_data_page.dart';
import '../utils/constants.dart';

class Support extends StatefulWidget {
  final ChattingListModel chatListModel;

  const Support({Key key, this.chatListModel}) : super(key: key);

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  final User user = FirebaseAuth.instance.currentUser;
  TextStyle senderStyle = TextStyle(color: Colors.black, fontSize: 16);
  TextStyle receiverStyle = TextStyle(color: Colors.white, fontSize: 16);
  Size get size => MediaQuery.of(context).size;

  Widget messageBubble({String message, String time, bool sender}) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 8),
      alignment: sender ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: sender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (sender)
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Text(
                '$time',
                style: TextStyle(fontSize: 12),
              ),
            ),
          Flexible(
            flex: 1,
            child: Material(
              elevation: 3.0,
              shadowColor: Colors.grey,
              type: MaterialType.canvas,
              borderRadius: sender
                  ? BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
              child: ClipRRect(
                borderRadius: sender
                    ? BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      )
                    : BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                  child: Align(
                    widthFactor: 1,
                    alignment: sender ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(
                      '$message',
                      style: sender ? senderStyle : receiverStyle,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: sender ? Colors.white : primaryColor,
                  ),
                ),
              ),
            ),
          ),
          if (!sender)
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                '$time',
                style: TextStyle(fontSize: 12),
              ),
            )
        ],
      ),
    );
  }

  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support'),
        centerTitle: true,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraint) => Container(
          child: Container(
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                ChatListRow(
                  model: widget.chatListModel,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(FirebaseHelper.chatCollection)
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
                      List<QueryDocumentSnapshot> documents = snapshot.data.docs;
                      List<ChattingModel> chats = [];
                      for (QueryDocumentSnapshot d in documents) {
                        ChattingModel model = ChattingModel.fromSnap(d);
                        if (model.receiver == widget.chatListModel.vendorId || model.receiver == user.uid) {
                          if (model.sender == widget.chatListModel.vendorId || model.sender == user.uid) {
                            if (model.bookingId == widget.chatListModel.bookingId) {
                              chats.add(model);
                            }
                          }
                        }
                      }
                      return documents.length <= 0
                          ? NoDataPage(
                              text: 'No Messages',
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: chats.length,
                              itemBuilder: (context, index) {
                                ChattingModel m = chats[index];
                                String date = Helper().getFormattedDate(m.time);
                                return messageBubble(message: m.message, sender: m.sender == user.uid, time: date);
                              },
                            );
                    },
                  ),
                ),
                Container(
                  height: 60,
                  color: Colors.white,
                  child: TextFormField(
                    expands: true,
                    cursorColor: Colors.black,
                    controller: _messageController,
                    maxLines: null,
                    minLines: null,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: primaryColor,
                        ),
                        onPressed: () async {
                          String message = _messageController.text.trim();
                          await MessageHelper().sendMessage(
                            message,
                            widget.chatListModel.vendorId,
                            widget.chatListModel.bookingId,
                            false,
                          );
                        },
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                      hintText: 'Add text to this message',
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
