import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/firebase_helper/firebase_helper.dart';
import 'package:trukapp/helper/helper.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import 'package:trukapp/models/notification_model.dart';
import 'package:trukapp/utils/constants.dart';
import 'package:trukapp/utils/no_data_page.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  final User user = FirebaseAuth.instance.currentUser;
  Widget notificationWidget({String time, String notification}) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$time',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            flex: 0,
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 0.2,
              child: Container(
                padding: EdgeInsets.only(bottom: 10, left: 5, top: 5),
                width: width,
                child: Text(
                  '$notification',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final locale = AppLocalizations.of(context).locale;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.getLocalizationValue(locale, LocaleKey.notification)),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        margin: const EdgeInsets.only(top: 30),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(FirebaseHelper.notificationCollection)
              .where('uid', isEqualTo: user.uid)
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
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Text(AppLocalizations.getLocalizationValue(locale, LocaleKey.noData)),
              );
            }

            List<NotificationModel> n = [];
            for (QueryDocumentSnapshot s in snapshot.data.docs) {
              NotificationModel notificationModel = NotificationModel.fromSnap(s);
              if (!notificationModel.isVendor) n.add(NotificationModel.fromSnap(s));
            }
            if (n.length <= 0) {
              return NoDataPage(
                text: AppLocalizations.getLocalizationValue(locale, LocaleKey.noNotification),
              );
            }
            FirebaseHelper().seenNotification(n);
            int count = snapshot.data.docs.length;
            return ListView.builder(
              itemCount: count,
              itemBuilder: (context, index) {
                NotificationModel notificationModel = NotificationModel.fromSnap(snapshot.data.docs[index]);
                if (notificationModel.isDriver) {
                  return Container();
                }
                return notificationWidget(
                  notification: notificationModel.message,
                  time: Helper().getFormattedDate(
                    notificationModel.time,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
