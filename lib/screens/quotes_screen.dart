import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/cancel_booking.dart';
import '../helper/request_status.dart';
import '../locale/app_localization.dart';
import '../locale/locale_keys.dart';
import '../models/chatting_list_model.dart';
import '../models/user_model.dart';
import '../screens/quote_summary_screen.dart';
import '../screens/support.dart';
import '../widgets/widgets.dart';
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

class _QuotesScreenState extends State<QuotesScreen>
    with AutomaticKeepAliveClientMixin {
  final User user = FirebaseAuth.instance.currentUser;
  bool isStatusUpdating = false;
  Locale locale;
  List<QuoteModel> filteredList = [];
  bool isFilter = false;
  var _radioValue = 'all';

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
        // actions: [
        //   InkWell(
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         CupertinoPageRoute(
        //           builder: (context) => MyRequestScreen(),
        //         ),
        //       );
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.only(right: 8.0, left: 3),
        //       child: Center(
        //         child: Text(
        //           AppLocalizations.getLocalizationValue(
        //               locale, LocaleKey.requestButton),
        //           style: TextStyle(color: primaryColor, fontSize: 17),
        //         ),
        //       ),
        //     ),
        //   )
        // ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: pQuotes.quotes.length <= 0
            ? NoDataPage(
                text: AppLocalizations.getLocalizationValue(
                    locale, LocaleKey.noQuotesRequested),
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onChanged: (string) {
                                if (string.trim().length <= 0 ||
                                    string.isEmpty) {
                                  setState(() {
                                    isFilter = false;
                                    filteredList = [];
                                  });
                                } else {
                                  setState(() {
                                    filteredList = pQuotes.quotes
                                        .where((element) =>
                                            element.bookingId
                                                .toString()
                                                .contains(string
                                                    .trim()
                                                    .toLowerCase()) ||
                                            element.price.contains(
                                                string.toLowerCase()) ||
                                            element.pickupDate
                                                .contains(string.toLowerCase()))
                                        .toList();
                                    isFilter = true;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: AppLocalizations.getLocalizationValue(
                                    locale, LocaleKey.searchHint),
                                border: OutlineInputBorder(),
                                labelText:
                                    AppLocalizations.getLocalizationValue(
                                        locale, LocaleKey.search),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.import_export_rounded),
                            onPressed: () {
                              Widget dialog = AlertDialog(
                                backgroundColor: Colors.white,
                                elevation: 8,
                                title: Text(
                                  "Filter Requests",
                                  style: TextStyle(
                                    fontFamily: 'Maven',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    RadioListTile(
                                      activeColor: Colors.green,
                                      value: "Low to High",
                                      title: Text("Low to High (Fare Price)"),
                                      groupValue: _radioValue,
                                      onChanged: (a) {
                                        setState(() {
                                          _radioValue = a;
                                          filteredList = [];
                                          filteredList = pQuotes.quotes;
                                          filteredList.sort(
                                            (a, b) => int.parse(a.price)
                                                .compareTo(int.parse(b.price)),
                                          );
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    RadioListTile(
                                      activeColor: Colors.green,
                                      value: "High to Low",
                                      title: Text("High to Low (Fare Price)"),
                                      groupValue: _radioValue,
                                      onChanged: (a) {
                                        setState(() {
                                          _radioValue = a;
                                          filteredList = [];
                                          filteredList = pQuotes.quotes;
                                          filteredList.sort(
                                            (a, b) => int.parse(b.price)
                                                .compareTo(int.parse(a.price)),
                                          );
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                              showGeneralDialog(
                                context: context,
                                pageBuilder: (context, anim1, anim2) => dialog,
                                barrierDismissible: true,
                                barrierLabel: '',
                                transitionBuilder:
                                    (context, anim1, anim2, child) {
                                  return Transform.scale(
                                    scale: anim1.value,
                                    origin: Offset(size.width * 0.5, -200),
                                    child: child,
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 400),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: isFilter
                          ? filteredList.length
                          : pQuotes.quotes.length,
                      itemBuilder: (context, index) {
                        QuoteModel model = isFilter
                            ? filteredList[index]
                            : pQuotes.quotes[index];
                        String docID = isFilter
                            ? filteredList[index].id
                            : pQuotes.quotes[index].id;
                        // if (model.status == RequestStatus.assigned) {
                        //   return Container();
                        // }
                        return buildQuoteBlock(model, docID, context);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Card buildQuoteBlock(QuoteModel model, String docID, BuildContext context) {
    double weight = 0;
    for (MaterialModel val in model.materials) {
      weight += val.quantity;
    }
    return Card(
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
                  "${model.truk}",
                  style: TextStyle(
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${model.trukName.toUpperCase()} $weight Kg",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${model.pickupDate}",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FutureBuilder<String>(
                      future: Helper().setLocationText(model.source),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text('Source');
                        }
                        return Text(
                          "${snapshot.data.split(',')[2].trimLeft()}",
                          style: TextStyle(fontSize: 16, color: primaryColor),
                          textAlign: TextAlign.left,
                        );
                      }),
                ),
                Expanded(
                  child: Icon(
                    Icons.arrow_right_alt_rounded,
                    color: primaryColor,
                  ),
                ),
                Expanded(
                  child: FutureBuilder<String>(
                    future: Helper().setLocationText(model.destination),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('Destination');
                      }
                      return Text(
                        "${snapshot.data.split(',')[2].trimLeft()}",
                        style: TextStyle(fontSize: 16, color: primaryColor),
                        textAlign: TextAlign.right,
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "Fare \u20B9 ${model.price}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            getButtons(docID, '${model.status}', model, context),
          ],
        ),
      ),
    );
  }

  Widget getButtons(
      String id, String status, QuoteModel quoteModel, BuildContext context) {
    // if (status == RequestStatus.accepted) {
    //   return Container(
    //     child: Text(
    //       AppLocalizations.getLocalizationValue(locale, LocaleKey.accept).toUpperCase(),
    //       style: TextStyle(color: Colors.green),
    //     ),
    //     padding: const EdgeInsets.all(5),
    //   );
    // }
    bool ss = true;
    final Size size = MediaQuery.of(context).size;
    FirebaseFirestore.instance
        .collection(FirebaseHelper.shipmentCollection)
        .where('bookingId', isEqualTo: quoteModel.bookingId)
        .get()
        .then((value) {
      for (var d in value.docs) {
        if (d.get('status') == RequestStatus.started) {
          setState(() {
            ss = false;
          });
        }
      }
    });
    if (status == RequestStatus.rejected) {
      return Container(
        child: Text(
          AppLocalizations.getLocalizationValue(locale, LocaleKey.reject)
              .toUpperCase(),
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
    if (status == RequestStatus.cancelled) {
      return Container(
        child: Text(
          'Cancelled'.toUpperCase(),
          style: TextStyle(color: Colors.red),
        ),
        padding: const EdgeInsets.all(5),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: status == RequestStatus.accepted
              ? Center(
                  child: Text(
                    AppLocalizations.getLocalizationValue(
                            locale, LocaleKey.accepted)
                        .toUpperCase(),
                    style: TextStyle(color: Colors.green),
                  ),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: isStatusUpdating
                      ? null
                      : () async {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  QuoteSummaryScreen(quoteModel: quoteModel),
                            ),
                          );
                        },
                  child: Center(
                    child: Text(
                      AppLocalizations.getLocalizationValue(
                          locale, LocaleKey.accept),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
        ),
        SizedBox(width: size.width * 0.075),
        Expanded(
          child: Visibility(
            visible: ss,
            child: OutlinedButton(
              style:
                  OutlinedButton.styleFrom(side: BorderSide(color: Colors.red)),
              onPressed: isStatusUpdating
                  ? null
                  : () async {
                      if (status == RequestStatus.accepted) {
                        reasonDialog(
                          context: context,
                          title: "Specify Reason",
                          onTap: (reason) async {
                            CancelBooking cancelBooking = CancelBooking(
                              collectionName: FirebaseHelper.quoteCollection,
                              docId: id,
                              status: RequestStatus.accepted,
                            );
                            cancelBooking.cancelBooking(
                              reason,
                              agent: quoteModel.agent,
                              bookingId: quoteModel.bookingId.toString(),
                              price: double.parse(quoteModel.price),
                            );
                            await FirebaseFirestore.instance
                                .collection('Truk')
                                .where(
                                  'trukNumber',
                                  isEqualTo: quoteModel.truk,
                                )
                                .get()
                                .then(
                              (value) {
                                for (var d in value.docs) {
                                  d.reference.update({'available': true});
                                }
                              },
                            );
                          },
                          price: '0',
                        );
                      } else {
                        showConfirmationDialog(
                          context: context,
                          title: AppLocalizations.getLocalizationValue(
                              locale, LocaleKey.reject),
                          subTitle: AppLocalizations.getLocalizationValue(
                              locale, LocaleKey.rejectConfirm),
                          onTap: () async {
                            await FirebaseHelper()
                                .updateQuoteStatus(id, RequestStatus.rejected);
                            await FirebaseFirestore.instance
                                .collection('Truks')
                                .where('trukNumber', isEqualTo: quoteModel.truk)
                                .get()
                                .then((value) {
                              for (var data in value.docs) {
                                data.reference.update({'available': true});
                              }
                            });
                          },
                        );
                      }
                    },
              child: Center(
                child: Text(
                  AppLocalizations.getLocalizationValue(
                    locale,
                    status == RequestStatus.accepted
                        ? LocaleKey.cancel
                        : LocaleKey.reject,
                  ),
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: size.width * 0.075),
        Expanded(
          child: status == RequestStatus.accepted
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  onPressed: () async {
                    CollectionReference reference = FirebaseFirestore.instance
                        .collection(FirebaseHelper.fleetOwnerCollection);

                    final d = await reference.doc(quoteModel.agent).get();
                    UserModel agent = UserModel.fromSnapshot(d);
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Support(
                          chatListModel: ChattingListModel(
                            id: '',
                            quoteModel: quoteModel,
                            userModel: agent,
                            time: DateTime.now().millisecondsSinceEpoch,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Text(
                      AppLocalizations.getLocalizationValue(
                          locale, LocaleKey.chat),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
