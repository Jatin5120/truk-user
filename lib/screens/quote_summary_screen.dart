import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:trukapp/firebase_helper/firebase_helper.dart';
import 'package:trukapp/helper/payment_type.dart';
import 'package:trukapp/helper/request_status.dart';
import 'package:trukapp/models/quote_model.dart';
import 'package:trukapp/models/user_model.dart';
import 'package:trukapp/models/wallet_model.dart';
import 'package:trukapp/widgets/widgets.dart';
import '../helper/helper.dart';

import '../models/material_model.dart';
import '../utils/constants.dart';

class QuoteSummaryScreen extends StatefulWidget {
  final QuoteModel quoteModel;
  final bool onlyView;
  const QuoteSummaryScreen({
    Key key,
    @required this.quoteModel,
    this.onlyView = false,
  }) : super(key: key);

  @override
  _QuoteSummaryScreenState createState() => _QuoteSummaryScreenState();
}

class _QuoteSummaryScreenState extends State<QuoteSummaryScreen> {
  bool isLoading = false;
  String sourceAddress = '';
  String destinationAddress = '';
  String payment;
  final User user = FirebaseAuth.instance.currentUser;

  Razorpay _razorpay;
  bool isPaymentLoading = false;

  createOrder(int amount, String email, String name) async {
    setState(() {
      isPaymentLoading = true;
    });
    var options = {
      'key': 'rzp_test_mJh9QWD7lZ8ToY',
      'amount': amount * 100, //in the smallest currency sub-unit.
      'name': '$name',
      'description': 'Quotation Payment ID - ${widget.quoteModel.bookingId}',
      'timeout': 300, // in seconds
      'currency': 'INR',
      'prefill': {'contact': '${user.phoneNumber.substring(3)}', 'email': '$email'}
    };
    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    //double amount = double.parse(_amountController.text);
    final time = DateTime.now().millisecondsSinceEpoch;
    await FirebaseHelper().updateQuoteStatus(widget.quoteModel.id, RequestStatus.accepted, paymentStatus: payment);
    await FirebaseHelper().transaction(
      response.paymentId,
      double.parse(widget.quoteModel.price),
      0,
      time,
      FirebaseHelper.transactionCollection,
      note: "Payment for booking Id - ${widget.quoteModel.bookingId}",
    );
    setState(() {
      isPaymentLoading = false;
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    setState(() {
      isPaymentLoading = false;
    });
    print("Payment Error : ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    setState(() {
      isPaymentLoading = false;
    });
    print(response.walletName);
  }

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    Helper().setLocationText(widget.quoteModel.source).then((value) => setState(() => sourceAddress = value));
    Helper().setLocationText(widget.quoteModel.destination).then((value) => setState(() => destinationAddress = value));
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final EdgeInsetsGeometry padding = EdgeInsets.only(left: 16, right: 16, top: 20);
    final TextStyle style = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    final pWallet = Provider.of<MyWallet>(context);
    final pUser = Provider.of<MyUser>(context);
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text('${widget.onlyView ? "Order" : "Quotation"} Summary'),
        ),
        bottomNavigationBar: widget.onlyView
            ? Container(
                height: 1,
              )
            : BottomAppBar(
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  height: 60,
                  width: size.width,
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: RaisedButton(
                    color: primaryColor,
                    onPressed: () async {
                      if (payment == null) {
                        Fluttertoast.showToast(msg: 'Please select payment type');
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });
                      if (payment == PaymentType.online) {
                        createOrder(int.parse(widget.quoteModel.price), pUser.user.email, pUser.user.name);
                      } else {
                        await FirebaseHelper()
                            .updateQuoteStatus(widget.quoteModel.id, RequestStatus.accepted, paymentStatus: payment);
                      }
                      setState(() {
                        isLoading = false;
                      });
                      paymentSuccessful(
                        context: context,
                        shipmentId: "${widget.quoteModel.bookingId}",
                        isPayment: true,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: Text(
                      'Accept Quotation',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
        body: Container(
          child: ListView(
            children: [
              Container(
                padding: padding,
                child: Text('Shipment Details', style: style),
              ),
              buildMaterialContainer(size),
              buildTypes(size),
              Container(
                padding: padding,
                child: Text('Pickup Location', style: style),
              ),
              createLocationBlock(size, 0),
              Container(
                padding: padding,
                child: Text('Drop Location', style: style),
              ),
              createLocationBlock(size, 1),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: Container(
                  child: Text(
                    '${widget.quoteModel.insured ? "With" : "Without"} insurance',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: Text(
                  "${PaymentType.paymentKeys[widget.quoteModel.paymentStatus]} - \u20B9${widget.quoteModel.price}",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: const Color(0xff76b448),
                    fontWeight: FontWeight.w500,
                    height: 2.142857142857143,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              if (!widget.onlyView)
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      Radio(
                        value: PaymentType.cod,
                        groupValue: payment,
                        onChanged: (b) {
                          setState(() {
                            payment = b;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(PaymentType.paymentKeys[PaymentType.cod]),
                      ),
                    ],
                  ),
                ),
              if (!widget.onlyView)
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      Radio(
                        value: PaymentType.online,
                        groupValue: payment,
                        onChanged: (b) {
                          setState(() {
                            payment = b;
                          });
                        },
                      ),
                      Expanded(
                        child: Text("${PaymentType.paymentKeys[PaymentType.online]}(Discount of 200)"),
                      ),
                    ],
                  ),
                ),
              if (!widget.onlyView)
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      Radio(
                        value: PaymentType.trukMoney,
                        groupValue: payment,
                        onChanged: double.parse(widget.quoteModel.price) > pWallet.myWallet.amount
                            ? null
                            : (b) {
                                setState(() {
                                  payment = b;
                                });
                              },
                      ),
                      Expanded(
                        child: Text(
                          "${PaymentType.paymentKeys[PaymentType.trukMoney]} ${double.parse(widget.quoteModel.price) > pWallet.myWallet.amount ? '(Not Enough balance)' : ''}",
                          style: TextStyle(
                            color: double.parse(widget.quoteModel.price) > pWallet.myWallet.amount
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMaterialContainer(Size size) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: const Color(0xfff8f8f8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.quoteModel.materials.length,
        itemBuilder: (context, index) {
          MaterialModel m = widget.quoteModel.materials[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  '${index + 1}. ',
                  style: TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Expanded(
                  child: Text(
                    '${m.materialName}',
                    style: TextStyle(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '${m.quantity} KG',
                  style: TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildTypes(Size size) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: const Color(0xfff8f8f8),
      ),
      child: Column(
        children: [
          createTypes('Mandate Type', widget.quoteModel.mandate),
          SizedBox(
            height: 10,
          ),
          createTypes('Load Type', widget.quoteModel.load),
          SizedBox(
            height: 10,
          ),
          createTypes('TruK Type', widget.quoteModel.truk),
        ],
      ),
    );
  }

  Widget createTypes(String heading, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$heading',
            style: TextStyle(fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          '$value',
          style: TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget createLocationBlock(Size size, int type) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: const Color(0xfff8f8f8),
      ),
      child: Text(
        type == 0 ? sourceAddress : destinationAddress,
      ),
    );
  }
}
