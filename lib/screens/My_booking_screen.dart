import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trukapp/helper/request_status.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import 'package:trukapp/models/shipment_model.dart';
import 'package:trukapp/screens/matDetails.dart';
import 'package:trukapp/screens/track.dart';
import '../firebase_helper/firebase_helper.dart';
import '../helper/helper.dart';
import '../models/material_model.dart';
import '../models/request_model.dart';
import '../utils/constants.dart';
import '../utils/no_data_page.dart';
import '../widgets/widgets.dart';

class MyBookingScreen extends StatefulWidget {
  @override
  _MyBookingScreenState createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
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
          AppLocalizations.getLocalizationValue(locale, LocaleKey.myBooking),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Shipment')
              .where('uid', isEqualTo: user.uid)
              .orderBy('bookingId', descending: true)
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
            print(snapshot.data.docs.length);
            int actualLength = 0;
            for (QueryDocumentSnapshot sd in snapshot.data.docs) {
              ShipmentModel model = ShipmentModel.fromSnapshot(sd);
              if (model.status != RequestStatus.completed) {
                actualLength++;
              }
            }
            print(actualLength);
            if (actualLength == 0) {
              return NoDataPage(
                text: AppLocalizations.getLocalizationValue(locale, LocaleKey.noData),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                ShipmentModel model = ShipmentModel.fromSnapshot(snapshot.data.docs[index]);
                String id = snapshot.data.docs[index].id;
                return model.status != RequestStatus.completed ? buildRequestCard(model, id) : Container();
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildRequestCard(ShipmentModel model, String id) {
    double weight = 0;
    for (MaterialModel val in model.materials) {
      weight += val.quantity;
    }
    print("Truck: ${model.truk}");
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      child: Card(
        elevation: 8,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${model.truk} $weight KG",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        SizedBox(height: 5),
                        FutureBuilder<String>(
                            future: Helper().setLocationText(model.source) ?? Future.value("Location,Location,location"),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text('Address...');
                              }
                              return Text(
                                "${snapshot.data.split(',')[2].trimLeft()}",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 12),
                              );
                            }),
                        FutureBuilder<String>(
                            future:
                            Helper().setLocationText(model.destination) ?? Future.value("Location,Location,location"),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text('|');
                              }
                              return Text(
                                "|\n${snapshot.data.split(',')[2].trimLeft()}",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 12),
                              );
                            }),
                        SizedBox(height: 5),
                        Text(
                          AppLocalizations.getLocalizationValue(this.locale, model.mandate),
                          style: TextStyle(fontSize: 12, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "ID ${model.bookingId}",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${model.pickupDate}",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${model.truk}",
                        style: TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${AppLocalizations.getLocalizationValue(this.locale, LocaleKey.insurance)} : ${model.insured ? AppLocalizations.getLocalizationValue(this.locale, LocaleKey.yes) : AppLocalizations.getLocalizationValue(this.locale, LocaleKey.no)}",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              RaisedButton(
                color: model.status==RequestStatus.started?primaryColor:Colors.grey,
                onPressed: (){
                  model.status==RequestStatus.started?Navigator.push(context, MaterialPageRoute(builder: (_)=>TrackNew(shipmentModel: model))):null;
                },
              child: Text(AppLocalizations.getLocalizationValue(this.locale, LocaleKey.track)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
