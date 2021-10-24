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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final locale = AppLocalizations.of(context).locale;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.getLocalizationValue(
            locale, LocaleKey.notification)),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        // margin: const EdgeInsets.only(top: 30),
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
                child: Text(
                  AppLocalizations.getLocalizationValue(
                      locale, LocaleKey.noData),
                ),
              );
            }

            List<NotificationModel> notifications = [];
            for (QueryDocumentSnapshot s in snapshot.data.docs) {
              NotificationModel notificationModel =
                  NotificationModel.fromSnap(s);
              if (!notificationModel.isVendor)
                notifications.add(notificationModel);
            }
            if (notifications.length <= 0) {
              return NoDataPage(
                text: AppLocalizations.getLocalizationValue(
                  locale,
                  LocaleKey.noNotification,
                ),
              );
            }
            FirebaseHelper().seenNotification(notifications);
            print(snapshot.data.docs.length);
            return ListView.builder(
              itemCount: snapshot.data.docs.length + 1,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                //This condition is to add small box at the end of the list
                if (snapshot.data.docs.length == index) {
                  return SizedBox(height: 40);
                }
                NotificationModel notificationModel =
                    NotificationModel.fromSnap(snapshot.data.docs[index]);
                if (notificationModel.isDriver) {
                  return SizedBox.shrink();
                }

                return _NotificationCard(
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

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    Key key,
    @required this.time,
    @required this.notification,
  }) : super(key: key);

  final String time;
  final String notification;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24)
          .copyWith(bottom: 0),
      semanticContainer: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              overflow: TextOverflow.clip,
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                time,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
