import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/firebase_helper/firebase_helper.dart';
import 'package:trukapp/helper/helper.dart';
import 'package:trukapp/helper/request_status.dart';
import 'package:trukapp/models/material_model.dart';
import 'package:trukapp/models/quote_model.dart';
import 'package:trukapp/models/shipment_model.dart';
import 'package:trukapp/utils/constants.dart';
import 'package:trukapp/utils/expandable_card_container.dart';
import '../utils/no_data_page.dart';

class MyShipment extends StatefulWidget {
  final Function onAppbarBack;

  const MyShipment({Key key, this.onAppbarBack}) : super(key: key);

  @override
  _MyShipmentState createState() => _MyShipmentState();
}

class _MyShipmentState extends State<MyShipment> {
  final User user = FirebaseAuth.instance.currentUser;
  bool isStatusUpdating = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Shipments'),
        centerTitle: true,
        leading: InkWell(
          onTap: widget.onAppbarBack,
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(FirebaseHelper.shipmentCollection)
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
                child: Text('No Data'),
              );
            }
            if (snapshot.data.size <= 0) {
              return NoDataPage(
                text: 'No Quotes',
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.size,
              itemBuilder: (context, index) {
                ShipmentModel model = ShipmentModel.fromSnapshot(snapshot.data.docs[index]);
                String docID = snapshot.data.docs[index].id;

                bool isCollapsed = true;
                return ExpandableCardContainer(
                  docID: docID,
                  model: model,
                  isCollapsed: isCollapsed,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildShipmentBlock(ShipmentModel model, String docID, bool isCollapsed) {
    double weight = 0;
    for (MaterialModel val in model.materials) {
      weight += val.quantity;
    }

    return Column(
      children: [
        Card(
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 15),
                            child: Image.asset(
                              'assets/images/delivery_truck.png',
                              height: 50,
                            ),
                          ),
                          Text(
                            "Order: ${model.bookingId}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quantity: $weight KG",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        FutureBuilder<String>(
                            future: Helper().setLocationText(model.destination),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text('Address...');
                              }
                              return Text(
                                "Destination: ${snapshot.data.split(',')[1].trimLeft()}",
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              );
                            }),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Date: ${model.pickupDate}",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Fare \u20B9 ${model.price}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getStatusWidget(String id, String status, ShipmentModel shipModel) {
    if (status == RequestStatus.pending) {
      return Container(
        child: Center(
          child: Text(
            'PENDING'.toUpperCase(),
            style: TextStyle(color: Colors.green),
          ),
        ),
        padding: const EdgeInsets.all(5),
      );
    }
    if (status == RequestStatus.completed) {
      return Container(
        child: Center(
          child: Text(
            'completed'.toUpperCase(),
            style: TextStyle(color: Colors.red),
          ),
        ),
        padding: const EdgeInsets.all(5),
      );
    }
    if (status == 'assigned') {
      return Container(
        child: Center(
          child: Text(
            'Assinged'.toUpperCase(),
            style: TextStyle(color: Colors.green),
          ),
        ),
        padding: const EdgeInsets.all(5),
      );
    }
    return Container(
      height: 30,
      child: RaisedButton(
        color: Colors.green,
        onPressed: isStatusUpdating
            ? null
            : () async {
                // Navigator.push(
                //     context,
                //     CupertinoPageRoute(
                //       builder: (context) => QuoteSummaryScreen(shipModel: shipModel),
                //     ));
                // setState(() {
                //   isStatusUpdating = true;
                // });
                //await FirebaseHelper().updateQuoteStatus(id, RequestStatus.accepted);
                // setState(() {
                //   isStatusUpdating = false;
                // });
              },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            "Track",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
