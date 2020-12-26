import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/firebase_helper/firebase_helper.dart';
import 'package:trukapp/helper/helper.dart';
import 'package:trukapp/models/material_model.dart';
import 'package:trukapp/models/quote_model.dart';
import 'package:trukapp/screens/my_request_screen.dart';
import 'package:trukapp/utils/constants.dart';

class QuotesScreen extends StatefulWidget {
  @override
  _QuotesScreenState createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  final User user = FirebaseAuth.instance.currentUser;
  bool isStatusUpdating = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Quotes",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => MyRequestScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 3),
              child: Center(
                child: Text(
                  'Request',
                  style: TextStyle(color: primaryColor, fontSize: 17),
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Quote')
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
              return Center(
                child: Text('No Data'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.size,
              itemBuilder: (context, index) {
                QuoteModel model = QuoteModel.fromSnapshot(snapshot.data.docs[index]);
                String docID = snapshot.data.docs[index].id;
                return buildQuoteBlock(model, docID);
              },
            );
          },
        ),
      ),
    );
  }

  Card buildQuoteBlock(QuoteModel model, String docID) {
    double weight = 0;
    for (MaterialModel val in model.materials) {
      weight += val.quantity;
    }
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model.trukName.toUpperCase()} (${model.truk}) $weight Kg",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  SizedBox(height: 5),
                  FutureBuilder<String>(
                      future: Helper().setLocationText(model.source),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Address...');
                        }
                        return Text(
                          "${snapshot.data.split(',')[1].trimLeft()}",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 12),
                        );
                      }),
                  FutureBuilder<String>(
                      future: Helper().setLocationText(model.destination),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('|');
                        }
                        return Text(
                          "|\n${snapshot.data.split(',')[1].trimLeft()}",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 12),
                        );
                      }),
                  SizedBox(height: 5),
                  getStatusWidget(docID, '${model.status}'),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  "\u20B9 ${model.price}",
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 30,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {},
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        "Chat",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getStatusWidget(String id, String status) {
    if (status == Status.ACCEPTED.toString()) {
      return Container(
        child: Center(
          child: Text(
            'Accepted'.toUpperCase(),
            style: TextStyle(color: Colors.green),
          ),
        ),
        padding: const EdgeInsets.all(5),
      );
    }
    if (status == Status.REJECTED.toString()) {
      return Container(
        child: Center(
          child: Text(
            'Rejected'.toUpperCase(),
            style: TextStyle(color: Colors.red),
          ),
        ),
        padding: const EdgeInsets.all(5),
      );
    }
    return Row(
      children: [
        Container(
          height: 30,
          child: RaisedButton(
            color: Colors.green,
            onPressed: isStatusUpdating
                ? null
                : () async {
                    setState(() {
                      isStatusUpdating = true;
                    });
                    await FirebaseHelper().updateQuoteStatus(id, Status.ACCEPTED.toString());
                    setState(() {
                      isStatusUpdating = false;
                    });
                  },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(
                "Accept",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          height: 30,
          child: FlatButton(
            onPressed: isStatusUpdating
                ? null
                : () async {
                    setState(() {
                      isStatusUpdating = true;
                    });
                    await FirebaseHelper().updateQuoteStatus(id, Status.REJECTED.toString());
                    setState(() {
                      isStatusUpdating = false;
                    });
                  },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(
                "Reject",
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
          ),
        )
      ],
    );
  }
}
