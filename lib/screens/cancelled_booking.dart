import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/models/canceled_booking_model.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import '../helper/helper.dart';
import '../utils/constants.dart';
import '../utils/no_data_page.dart';

class CancelledBookings extends StatefulWidget {
  @override
  _CancelledBookingsState createState() => _CancelledBookingsState();
}

class _CancelledBookingsState extends State<CancelledBookings> {
  final User user = FirebaseAuth.instance.currentUser;
  Locale locale;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    locale = AppLocalizations.of(context).locale;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          AppLocalizations.getLocalizationValue(locale, LocaleKey.cancelled),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('CancelledBooking')
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
                child: Text(AppLocalizations.getLocalizationValue(
                    locale, LocaleKey.noData)),
              );
            }
            if (snapshot.data.docs.length == 0) {
              return NoDataPage(
                text: AppLocalizations.getLocalizationValue(
                    locale, LocaleKey.noQuotesRequested),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                CancelModal model =
                    CancelModal.fromSnap(snapshot.data.docs[index]);
                return _CancelledBookinCard(model);
              },
            );
          },
        ),
      ),
    );
  }
}

class _CancelledBookinCard extends StatelessWidget {
  const _CancelledBookinCard(this.cancelModal, {Key key}) : super(key: key);

  final CancelModal cancelModal;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Colors.white,
      margin:
          EdgeInsets.symmetric(horizontal: 8, vertical: 24).copyWith(bottom: 0),
      semanticContainer: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "ID ${cancelModal.bookingId}",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "Cancellation Charges - Rs ${cancelModal.amount}",
              style: TextStyle(fontSize: 16, color: primaryColor),
            ),
            SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                Helper().getFormattedDate(cancelModal.time),
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
