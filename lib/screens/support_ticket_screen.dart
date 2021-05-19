import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trukapp/helper/helper.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import 'package:trukapp/models/chat_controller.dart';
import '../models/chatting_list_model.dart';
import '../utils/constants.dart';
import '../screens/support.dart';
import '../utils/no_data_page.dart';

class SupportTicketScreen extends StatefulWidget {
  @override
  _SupportTicketScreenState createState() => _SupportTicketScreenState();
}

class _SupportTicketScreenState extends State<SupportTicketScreen> {
  final User user = FirebaseAuth.instance.currentUser;
  Locale locale;
  @override
  void initState() {
    super.initState();
    //Provider.of<MyChattingList>(context, listen: false).getAllChats();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final pChatList = Provider.of<ChatController>(context);
    locale = AppLocalizations.of(context).locale;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.getLocalizationValue(locale, LocaleKey.supportTicket),
        ),
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
                    text: AppLocalizations.getLocalizationValue(locale, LocaleKey.noData),
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
          padding: const EdgeInsets.all(08.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                radius: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: chattingListModel.userModel.image == 'na'
                      ? Image.asset(
                          'assets/images/no_data.png',
                          height: 60,
                          width: 60,
                          fit: BoxFit.contain,
                        )
                      : CachedNetworkImage(
                          imageUrl: chattingListModel.userModel.image,
                          fit: BoxFit.cover,
                          height: 60,
                          width: 60,
                        ),
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Expanded(
                child: Padding(
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
                          // FutureBuilder<String>(
                          //   future: Helper().setLocationText(chattingListModel.quoteModel.source),
                          //   builder: (context, snapshot) {
                          //     if (!snapshot.hasData) {
                          //       return Text('Address...');
                          //     }
                          //     return Text(
                          //       snapshot.data.split(",")[2] ?? snapshot.data.split(",")[3],
                          //       overflow: TextOverflow.ellipsis,
                          //       maxLines: 1,
                          //       textWidthBasis: TextWidthBasis.parent,
                          //     );
                          //   },
                          // ),
                          // Text("-"),
                          FutureBuilder<String>(
                            future: Helper().setLocationText(chattingListModel.quoteModel.destination),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text('Address...');
                              }
                              return Text(
                                "Dest -" + snapshot.data.split(",")[2] ?? snapshot.data.split(",")[3],
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
              ),
              Padding(
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
            ],
          ),
        ),
      ),
    );
  }
}
