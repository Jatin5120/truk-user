import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import 'package:trukapp/screens/quote_summary_screen.dart';
import 'package:trukapp/utils/constants.dart';
import '../models/chatting_list_model.dart';

class ChatListRow extends StatelessWidget {
  final ChattingListModel model;
  const ChatListRow({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context).locale;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => QuoteSummaryScreen(
              quoteModel: model.quoteModel,
              onlyView: true,
            ),
          ),
        );
      },
      child: Card(
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 5),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    padding: EdgeInsets.all(model.userModel.image == 'na' ? 8 : 2),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: model.userModel.image == 'na'
                        ? Center(
                            child: Image.asset(
                              'assets/images/no_data.png',
                              fit: BoxFit.contain,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: CachedNetworkImage(
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
                          '${AppLocalizations.getLocalizationValue(locale, LocaleKey.bookingId)} : ${model.quoteModel.bookingId}',
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${AppLocalizations.getLocalizationValue(locale, LocaleKey.pickupDate)} : ${model.quoteModel.pickupDate}',
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Center(
                child: Text(
                  '\u20B9 ${model.quoteModel.price}',
                  style: TextStyle(fontSize: 20, color: primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
