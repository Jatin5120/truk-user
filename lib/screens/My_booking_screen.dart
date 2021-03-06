import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:trukapp/helper/request_status.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import 'package:trukapp/screens/matDetails.dart';
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
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Request')
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
                child: Text(AppLocalizations.getLocalizationValue(
                    locale, LocaleKey.noData)),
              );
            }
            int actualLength = 0;
            for (QueryDocumentSnapshot sd in snapshot.data.docs) {
              RequestModel model = RequestModel.fromSnapshot(sd);
              if (model.status == RequestStatus.pending) {
                actualLength++;
              }
            }
            if (actualLength == 0) {
              return NoDataPage(
                text: AppLocalizations.getLocalizationValue(
                    locale, LocaleKey.noQuotesRequested),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                RequestModel model =
                    RequestModel.fromSnapshot(snapshot.data.docs[index]);
                String id = snapshot.data.docs[index].id;
                return model.status == RequestStatus.pending
                    ? buildRequestCard(model, id)
                    : SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildRequestCard(RequestModel model, String id) {
    double weight = 0;
    for (MaterialModel val in model.materials) {
      weight += val.quantity;
    }
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      secondaryActions: [
        IconSlideAction(
          icon: Icons.edit,
          color: Colors.blue,
          closeOnTap: true,
          onTap: () {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => MaterialDetails(
                  prevQuote: model,
                  isUpdate: true,
                ),
              ),
            );
          },
        ),
        IconSlideAction(
          icon: Icons.delete,
          color: Colors.red,
          closeOnTap: true,
          onTap: () {
            showConfirmationDialog(
              context: context,
              onTap: () async {
                await FirebaseHelper().deleteRequest(id);
              },
              title: AppLocalizations.getLocalizationValue(
                  locale, LocaleKey.delete),
              subTitle: AppLocalizations.getLocalizationValue(
                  locale, LocaleKey.deleteConfirm),
            );
          },
        ),
      ],
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.getLocalizationValue(this.locale, model.truk)} $weight KG",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    "ID ${model.bookingId}",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FutureBuilder<String>(
                      future: Helper().setLocationText(model.source) ??
                          Future.value("Location,Location,location"),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Source');
                        }
                        return Text(
                          "${snapshot.data.split(',')[2].trimLeft()}",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 16, color: primaryColor),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Icon(
                      Icons.arrow_right_alt_rounded,
                      color: primaryColor,
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<String>(
                      future: Helper().setLocationText(model.destination) ??
                          Future.value("Location,Location,location"),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Destination');
                        }
                        return Text(
                          "${snapshot.data.split(',')[2].trimLeft()}",
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 16, color: primaryColor),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.getLocalizationValue(this.locale, LocaleKey.insurance)} : ${model.insured ? AppLocalizations.getLocalizationValue(this.locale, LocaleKey.yes) : AppLocalizations.getLocalizationValue(this.locale, LocaleKey.no)}",
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    "${model.pickupDate}",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // AppLocalizations.getLocalizationValue(
                    //     this.locale, model.mandate),
              AppLocalizations.getLocalizationValue(
              this.locale,LocaleKey.onDemand),
                    style: TextStyle(fontSize: 14, color: Colors.orange),
                   ),
                  Text(
                    AppLocalizations.getLocalizationValue(
                        this.locale, model.truk),
                    style: TextStyle(fontSize: 14, color: Colors.orange),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             "${AppLocalizations.getLocalizationValue(this.locale, model.truk)} $weight KG",
              //             style: TextStyle(
              //                 fontWeight: FontWeight.bold, fontSize: 12),
              //           ),
              //           SizedBox(height: 5),
              //           FutureBuilder<String>(
              //               future: Helper().setLocationText(model.source) ??
              //                   Future.value("Location,Location,location"),
              //               builder: (context, snapshot) {
              //                 if (!snapshot.hasData) {
              //                   return Text('Address...');
              //                 }
              //                 return Text(
              //                   "${snapshot.data.split(',')[2].trimLeft()}",
              //                   textAlign: TextAlign.start,
              //                   style: TextStyle(fontSize: 12),
              //                 );
              //               }),
              //           FutureBuilder<String>(
              //               future:
              //                   Helper().setLocationText(model.destination) ??
              //                       Future.value("Location,Location,location"),
              //               builder: (context, snapshot) {
              //                 if (!snapshot.hasData) {
              //                   return Text('|');
              //                 }
              //                 return Text(
              //                   "|\n${snapshot.data.split(',')[2].trimLeft()}",
              //                   textAlign: TextAlign.start,
              //                   style: TextStyle(fontSize: 12),
              //                 );
              //               }),
              //           SizedBox(height: 5),
              //           Text(
              //             AppLocalizations.getLocalizationValue(
              //                 this.locale, model.mandate),
              //             style: TextStyle(fontSize: 12, color: Colors.orange),
              //           ),
              //         ],
              //       ),
              //     ),
              //     Column(
              //       mainAxisSize: MainAxisSize.min,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         Text(
              //           "ID ${model.bookingId}",
              //           style: TextStyle(fontSize: 12),
              //         ),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text(
              //           "${model.pickupDate}",
              //           style: TextStyle(fontSize: 12),
              //         ),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text(
              //           AppLocalizations.getLocalizationValue(
              //               this.locale, model.truk),
              //           style: TextStyle(fontSize: 12, color: Colors.orange),
              //         ),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Text(
              //           "${AppLocalizations.getLocalizationValue(this.locale, LocaleKey.insurance)} : ${model.insured ? AppLocalizations.getLocalizationValue(this.locale, LocaleKey.yes) : AppLocalizations.getLocalizationValue(this.locale, LocaleKey.no)}",
              //           style: TextStyle(fontSize: 12),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:trukapp/helper/request_status.dart';
// import 'package:trukapp/locale/app_localization.dart';
// import 'package:trukapp/locale/locale_keys.dart';
// import 'package:trukapp/models/shipment_model.dart';
// import 'package:trukapp/screens/matDetails.dart';
// import 'package:trukapp/screens/track.dart';
// import '../firebase_helper/firebase_helper.dart';
// import '../helper/helper.dart';
// import '../models/material_model.dart';
// import '../models/request_model.dart';
// import '../utils/constants.dart';
// import '../utils/no_data_page.dart';
// import '../widgets/widgets.dart';
//
// class MyBookingScreen extends StatefulWidget {
//   @override
//   _MyBookingScreenState createState() => _MyBookingScreenState();
// }
//
// class _MyBookingScreenState extends State<MyBookingScreen> {
//   final User user = FirebaseAuth.instance.currentUser;
//   Locale locale;
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     locale = AppLocalizations.of(context).locale;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: Text(
//           AppLocalizations.getLocalizationValue(locale, LocaleKey.myBooking),
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       body: Container(
//         height: size.height,
//         width: size.width,
//         padding: const EdgeInsets.all(16),
//         child: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('Shipment')
//               .where('uid', isEqualTo: user.uid)
//               .orderBy('bookingId', descending: true)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
//                 ),
//               );
//             }
//             if (snapshot.hasError || !snapshot.hasData) {
//               return Center(
//                 child: Text(AppLocalizations.getLocalizationValue(locale, LocaleKey.noData)),
//               );
//             }
//             print(snapshot.data.docs.length);
//             int actualLength = 0;
//             for (QueryDocumentSnapshot sd in snapshot.data.docs) {
//               ShipmentModel model = ShipmentModel.fromSnapshot(sd);
//               if (model.status != RequestStatus.completed) {
//                 actualLength++;
//               }
//             }
//             print(actualLength);
//             if (actualLength == 0) {
//               return NoDataPage(
//                 text: AppLocalizations.getLocalizationValue(locale, LocaleKey.noData),
//               );
//             }
//             return ListView.builder(
//               itemCount: snapshot.data.docs.length,
//               itemBuilder: (context, index) {
//                 ShipmentModel model = ShipmentModel.fromSnapshot(snapshot.data.docs[index]);
//                 String id = snapshot.data.docs[index].id;
//                 return model.status != RequestStatus.completed ? buildRequestCard(model, id) : Container();
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget buildRequestCard(ShipmentModel model, String id) {
//     double weight = 0;
//     for (MaterialModel val in model.materials) {
//       weight += val.quantity;
//     }
//     print("Truck: ${model.truk}");
//     return Slidable(
//       actionPane: SlidableScrollActionPane(),
//       child: Card(
//         elevation: 8,
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "${model.truk} $weight KG",
//                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                         ),
//                         SizedBox(height: 5),
//                         FutureBuilder<String>(
//                             future: Helper().setLocationText(model.source) ?? Future.value("Location,Location,location"),
//                             builder: (context, snapshot) {
//                               if (!snapshot.hasData) {
//                                 return Text('Address...');
//                               }
//                               return Text(
//                                 "${snapshot.data.split(',')[2].trimLeft()}",
//                                 textAlign: TextAlign.start,
//                                 style: TextStyle(fontSize: 12),
//                               );
//                             }),
//                         FutureBuilder<String>(
//                             future:
//                             Helper().setLocationText(model.destination) ?? Future.value("Location,Location,location"),
//                             builder: (context, snapshot) {
//                               if (!snapshot.hasData) {
//                                 return Text('|');
//                               }
//                               return Text(
//                                 "|\n${snapshot.data.split(',')[2].trimLeft()}",
//                                 textAlign: TextAlign.start,
//                                 style: TextStyle(fontSize: 12),
//                               );
//                             }),
//                         SizedBox(height: 5),
//                         Text(
//                           AppLocalizations.getLocalizationValue(this.locale, model.mandate),
//                           style: TextStyle(fontSize: 12, color: Colors.orange),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         "ID ${model.bookingId}",
//                         style: TextStyle(fontSize: 12),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         "${model.pickupDate}",
//                         style: TextStyle(fontSize: 12),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         "${model.truk}",
//                         style: TextStyle(fontSize: 12, color: Colors.orange),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         "${AppLocalizations.getLocalizationValue(this.locale, LocaleKey.insurance)} : ${model.insured ? AppLocalizations.getLocalizationValue(this.locale, LocaleKey.yes) : AppLocalizations.getLocalizationValue(this.locale, LocaleKey.no)}",
//                         style: TextStyle(fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               RaisedButton(
//                 color: model.status==RequestStatus.started?primaryColor:Colors.grey,
//                 onPressed: (){
//                   model.status==RequestStatus.started?Navigator.push(context, MaterialPageRoute(builder: (_)=>TrackNew(shipmentModel: model))):null;
//                 },
//               child: Text(AppLocalizations.getLocalizationValue(this.locale, LocaleKey.track)),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
