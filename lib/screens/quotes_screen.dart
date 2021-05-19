import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:provider/provider.dart';
import 'package:trukapp/helper/cancel_booking.dart';
import 'package:trukapp/helper/request_status.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import 'package:trukapp/models/chatting_list_model.dart';
import 'package:trukapp/models/user_model.dart';
import 'package:trukapp/screens/quote_summary_screen.dart';
import 'package:trukapp/screens/support.dart';
import 'package:trukapp/widgets/widgets.dart';
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

class _QuotesScreenState extends State<QuotesScreen> with AutomaticKeepAliveClientMixin {
  final User user = FirebaseAuth.instance.currentUser;
  bool isStatusUpdating = false;
  Locale locale;
  List<QuoteModel> filteredList = [];
  bool isFilter = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    locale = AppLocalizations.of(context).locale;
    final size = MediaQuery.of(context).size;
    final pQuotes = Provider.of<MyQuotes>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          AppLocalizations.getLocalizationValue(locale, LocaleKey.quotes),
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
                  AppLocalizations.getLocalizationValue(locale, LocaleKey.requestButton),
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
        child: pQuotes.quotes.length <= 0
            ? NoDataPage(
                text: AppLocalizations.getLocalizationValue(locale, LocaleKey.noQuotesRequested),
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
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
                            filteredList = pQuotes.quotes
                                .where((element) =>
                                    element.bookingId.toString().contains(string.trim().toLowerCase()) ||
                                    element.price.contains(string.toLowerCase()) ||
                                    element.pickupDate.contains(string.toLowerCase()))
                                .toList();
                            isFilter = true;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.getLocalizationValue(locale, LocaleKey.searchHint),
                        border: OutlineInputBorder(),
                        labelText: AppLocalizations.getLocalizationValue(locale, LocaleKey.search),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: isFilter ? filteredList.length : pQuotes.quotes.length,
                      itemBuilder: (context, index) {
                        QuoteModel model = isFilter ? filteredList[index] : pQuotes.quotes[index];
                        String docID = isFilter ? filteredList[index].id : pQuotes.quotes[index].id;
                        // if (model.status == RequestStatus.assigned) {
                        //   return Container();
                        // }
                        return buildQuoteBlock(model, docID);
                      },
                    ),
                  ],
                ),
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
                          "${snapshot.data.split(',')[2].trimLeft()}",
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
                          "|\n${snapshot.data.split(',')[2].trimLeft()}",
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
                  style: TextStyle(fontSize: 13, color: Colors.orange, fontWeight: FontWeight.bold),
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
                      CollectionReference reference =
                          FirebaseFirestore.instance.collection(FirebaseHelper.fleetOwnerCollection);

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
                              time: DateTime.now().millisecondsSinceEpoch,
                            ),
                          ),
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        AppLocalizations.getLocalizationValue(locale, LocaleKey.chat),
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
    // if (status == RequestStatus.accepted) {
    //   return Container(
    //     child: Text(
    //       AppLocalizations.getLocalizationValue(locale, LocaleKey.accept).toUpperCase(),
    //       style: TextStyle(color: Colors.green),
    //     ),
    //     padding: const EdgeInsets.all(5),
    //   );
    // }
    if (status == RequestStatus.rejected) {
      return Container(
        child: Text(
          AppLocalizations.getLocalizationValue(locale, LocaleKey.reject).toUpperCase(),
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
        status == RequestStatus.accepted
            ? Container(
                child: Text(
                  AppLocalizations.getLocalizationValue(locale, LocaleKey.accept).toUpperCase(),
                  style: TextStyle(color: Colors.green),
                ),
                padding: const EdgeInsets.all(5),
              )
            : Container(
                height: 30,
                child: RaisedButton(
                  color: Colors.green,
                  onPressed: isStatusUpdating
                      ? null
                      : () async {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => QuoteSummaryScreen(quoteModel: quoteModel),
                              ));
                        },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text(
                      AppLocalizations.getLocalizationValue(locale, LocaleKey.accept),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Container(
            height: 30,
            child: FlatButton(
              onPressed: isStatusUpdating
                  ? null
                  : () async {
                      if (status == RequestStatus.accepted) {
                        reasonDialog(
                            context: context,
                            title: "Specify Reason",
                            onTap: (reason) {
                              CancelBooking cancelBooking = CancelBooking(
                                  collectionName: FirebaseHelper.quoteCollection,
                                  docId: id,
                                  status: RequestStatus.accepted);
                              cancelBooking.cancelBooking(reason,
                                  agent: quoteModel.agent,
                                  bookingId: quoteModel.bookingId.toString(),
                                  price: double.parse(quoteModel.price));
                            });
                      } else {
                        showConfirmationDialog(
                          context: context,
                          title: AppLocalizations.getLocalizationValue(locale, LocaleKey.reject),
                          subTitle: AppLocalizations.getLocalizationValue(locale, LocaleKey.rejectConfirm),
                          onTap: () async {
                            await FirebaseHelper().updateQuoteStatus(id, RequestStatus.rejected);
                          },
                        );
                      }
                    },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  AppLocalizations.getLocalizationValue(
                      locale, status == RequestStatus.accepted ? LocaleKey.cancel : LocaleKey.reject),
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
