import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../firebase_helper/firebase_helper.dart';
import '../helper/helper.dart';
import '../models/material_model.dart';
import '../models/request_model.dart';
import '../utils/constants.dart';
import '../utils/no_data_page.dart';
import '../widgets/widgets.dart';

class MyRequestScreen extends StatefulWidget {
  @override
  _MyRequestScreenState createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  final User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "My Requests",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(16),
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
                child: Text('No Data'),
              );
            }
            if (snapshot.data.size <= 0) {
              return NoDataPage(
                text: 'No Quotes Requested',
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                RequestModel model = RequestModel.fromSnapshot(snapshot.data.docs[index]);
                String id = snapshot.data.docs[index].id;
                return buildRequestCard(model, id);
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
          icon: Icons.delete,
          color: Colors.red,
          closeOnTap: true,
          onTap: () {
            showConfirmationDialog(
              context: context,
              onTap: () async {
                await FirebaseHelper().deleteRequest(id);
              },
              title: 'Delete',
              subTitle: 'Do you want to delete the request?',
            );
          },
        ),
      ],
      child: Card(
        elevation: 8,
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
                      "${model.truk} $weight KG",
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
                    Text(
                      "${model.mandate}",
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
                    "Insurance : ${model.insured ? 'Yes' : 'No'}",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
