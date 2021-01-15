import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/screens/quote_summary_screen.dart';
import 'package:trukapp/utils/constants.dart';
import '../models/chatting_list_model.dart';

class ChatListRow extends StatelessWidget {
  final ChattingListModel model;
  const ChatListRow({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => QuoteSummaryScreen(
                quoteModel: model.quoteModel,
                onlyView: true,
              ),
            ));
      },
      child: Card(
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: 60,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: model.userModel.image == 'na'
                      ? Image.asset(
                          'assets/images/no_data.png',
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: model.userModel.image,
                          fit: BoxFit.cover,
                          height: 58,
                          width: 58,
                        ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Id : ${model.quoteModel.bookingId}',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Vendor Name : ${model.userModel.name}',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Pickup Date : ${model.quoteModel.pickupDate}',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}