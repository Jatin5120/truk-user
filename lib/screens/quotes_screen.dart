import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/helper/request_status.dart';
import 'package:trukapp/models/chatting_list_model.dart';
import 'package:trukapp/models/user_model.dart';
import 'package:trukapp/screens/quote_summary_screen.dart';
import 'package:trukapp/screens/support.dart';
import '../firebase_helper/firebase_helper.dart';
import '../helper/helper.dart';
import '../models/material_model.dart';
import '../models/quote_model.dart';
import '../screens/my_request_screen.dart';
import '../utils/constants.dart';
import '../utils/no_data_page.dart';

class QuotesScreen extends StatefulWidget {
  @override
  _QuotesScreenState createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  final User user = FirebaseAuth.instance.currentUser;
  bool isStatusUpdating = false;
  List<QuoteModel> filteredList = [];
  bool isFilter = false;
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
              return NoDataPage(
                text: 'No Quotes',
              );
            }
            List<QuoteModel> list = [];
            for (QueryDocumentSnapshot m in snapshot.data.docs) {
              list.add(QuoteModel.fromSnapshot(m));
            }
            return Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (string) {
                      if (string.trim().length <= 0 || string.isEmpty) {
                        setState(() {
                          isFilter = false;
                          filteredList = [];
                        });
                      } else {
                        setState(() {
                          filteredList = list
                              .where((element) =>
                                  element.bookingId
                                      .toString()
                                      .contains(string.trim().toLowerCase()) ||
                                  element.price
                                      .contains(string.toLowerCase()) ||
                                  element.pickupDate
                                      .contains(string.toLowerCase()))
                              .toList();
                          isFilter = true;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Type Order Id, pickup date, fare...',
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        isFilter ? filteredList.length : snapshot.data.size,
                    itemBuilder: (context, index) {
                      QuoteModel model = isFilter
                          ? filteredList[index]
                          : QuoteModel.fromSnapshot(snapshot.data.docs[index]);
                      String docID = isFilter
                          ? filteredList[index]
                          : snapshot.data.docs[index].id;
                      return buildQuoteBlock(model, docID);
                    },
                  ),
                ],
              ),
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
                  getStatusWidget(docID, '${model.status}', model),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${model.pickupDate}",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${model.truk}",
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
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
                Container(
                  height: 30,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () async {
                      CollectionReference reference = FirebaseFirestore.instance
                          .collection(FirebaseHelper.fleetOwnerCollection);

                      final d = await reference.doc(model.agent).get();
                      UserModel agent = UserModel.fromSnapshot(d);
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => Support(
                              chatListModel: ChattingListModel(
                                  id: '',
                                  quoteModel: model,
                                  userModel: agent,
                                  time: DateTime.now().millisecondsSinceEpoch),
                            ),
                          ));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
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

  Widget getStatusWidget(String id, String status, QuoteModel quoteModel) {
    if (status == RequestStatus.accepted) {
      return Container(
        child: Text(
          'Accepted'.toUpperCase(),
          style: TextStyle(color: Colors.green),
        ),
        padding: const EdgeInsets.all(5),
      );
    }
    if (status == RequestStatus.rejected) {
      return Container(
        child: Text(
          'Rejected'.toUpperCase(),
          style: TextStyle(color: Colors.red),
        ),
        padding: const EdgeInsets.all(5),
      );
    }
    if (status == 'assigned') {
      return Container(
        child: Text(
          'Assinged'.toUpperCase(),
          style: TextStyle(color: Colors.green),
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
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              QuoteSummaryScreen(quoteModel: quoteModel),
                        ));
                  },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                    // setState(() {
                    //   isStatusUpdating = true;
                    // });
                    await FirebaseHelper()
                        .updateQuoteStatus(id, RequestStatus.rejected);
                    // setState(() {
                    //   isStatusUpdating = false;
                    // });
                  },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
