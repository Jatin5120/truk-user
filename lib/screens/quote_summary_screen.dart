import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:trukapp/firebase_helper/firebase_helper.dart';
import 'package:trukapp/helper/payment_type.dart';
import 'package:trukapp/helper/request_status.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import 'package:trukapp/models/coupon_model.dart';
import 'package:trukapp/models/quote_model.dart';
import 'package:trukapp/models/user_model.dart';
import 'package:trukapp/models/wallet_model.dart';
import 'package:trukapp/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helper/helper.dart';
import '../models/material_model.dart';
import '../utils/constants.dart';

class QuoteSummaryScreen extends StatefulWidget {
  final QuoteModel quoteModel;
  final bool onlyView;
  final String id;
  const QuoteSummaryScreen({
    Key key,
    @required this.quoteModel,
    this.id,
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
  Locale locale;
  Razorpay _razorpay;
  bool isPaymentLoading = false;
  final _couponController = TextEditingController();
  bool isCouponApplied = false;
  double discountedPrice = 0;
  String coupon = "";

  var advance=0.0;

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
    await FirebaseHelper().insertPayout(
      agent: widget.quoteModel.agent,
      amount: double.parse(widget.quoteModel.price),
      bookingId: widget.quoteModel.bookingId,
      status: 'pending',
      time: time,
    );
    if (isCouponApplied)
      await FirebaseHelper()
          .insertCouponUsage(quoteModel: widget.quoteModel, coupon: coupon, discountPrice: discountedPrice);
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
      isCouponApplied = false;
      coupon = "";
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
  getAdvance () async {
    await FirebaseFirestore.instance.collection(FirebaseHelper.quoteCollection).where('bookingId',isEqualTo: widget.quoteModel.bookingId).get().then((value){
      for(var d in value.docs){
        setState(() {
          advance=d.get('advance');
        });
      }
    });
  }


  Future<String> getInvoice() async{
    String Invoice;
   final data = await FirebaseFirestore.instance.collection(FirebaseHelper.invoiceCollection).where('id',isEqualTo: widget.id).get();
     data.docs.forEach((element) {
     Invoice =  element.get('invoice');
   });
   return Invoice;
  }

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    Helper().setLocationText(widget.quoteModel.source).then((value) => setState(() => sourceAddress = value));
    Helper().setLocationText(widget.quoteModel.destination).then((value) => setState(() => destinationAddress = value));
    getAdvance();
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final EdgeInsetsGeometry padding = EdgeInsets.only(left: 16, right: 16, top: 20);
    final TextStyle style = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    final pWallet = Provider.of<MyWallet>(context);
    final pUser = Provider.of<MyUser>(context);
    locale = AppLocalizations.of(context).locale;
    String fineString = pWallet.model.amount < 0
        ? "+" +
            pWallet.model.amount.abs().roundToDouble().toString() +
            "=" +
            (double.parse(widget.quoteModel.price) + pWallet.model.amount.abs()).roundToDouble().toString() +
            "(Previous Cancellation Charge)"
        : '';
    String title = AppLocalizations.getLocalizationValue(locale, LocaleKey.orderSummary);
    if (!widget.onlyView) {
      title = AppLocalizations.getLocalizationValue(locale, LocaleKey.quotes);
    }
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(title),
        ),
        bottomNavigationBar: widget.onlyView
            ?
        widget.quoteModel.status == RequestStatus.completed?
        BottomAppBar(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            height: 60,
            width: size.width,
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: RaisedButton(
              color: primaryColor,
              onPressed: () async {
                String invoice = await getInvoice();
                if (await canLaunch(invoice)) {
                  await launch(invoice);
                } else {
                  throw 'Could not launch $invoice';
                }
              },
              child: Text(
                'Invoice',
                // AppLocalizations.getLocalizationValue(locale, LocaleKey.accept),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        )
            :Container(
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
                      double fine = pWallet.model.amount >= 0.0 ? 0 : pWallet.model.amount.abs();
                      print(fine);
                      double totalPrice =
                          isCouponApplied ? discountedPrice + fine : double.parse(widget.quoteModel.price) + fine;
                      if (payment == PaymentType.online) {
                        if (pWallet.model.amount < 0) {
                          await FirebaseHelper()
                              .updateWallet(widget.quoteModel.bookingId.toString(), double.parse(fine.toString()), 1);
                        }
                        int price = int.parse(widget.quoteModel.price);
                        createOrder(totalPrice.toInt(), pUser.user.email, pUser.user.name);
                      } else if (payment == PaymentType.trukMoney) {
                        final time = DateTime.now().millisecondsSinceEpoch;
                        await FirebaseHelper().insertPayout(
                          agent: widget.quoteModel.agent,
                          amount: totalPrice,
                          bookingId: widget.quoteModel.bookingId,
                          status: 'pending',
                          time: time,
                        );

                        await FirebaseHelper().updateWallet(widget.quoteModel.bookingId.toString(), totalPrice, 0);

                        paymentSuccessful(
                          context: context,
                          shipmentId: "${widget.quoteModel.bookingId}",
                          isPayment: true,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        );
                      } else {
                        if (pWallet.model.amount < 0) {
                          await FirebaseHelper()
                              .updateWallet(widget.quoteModel.bookingId.toString(), double.parse(fine.toString()), 1);
                        }
                        await FirebaseHelper()
                            .updateQuoteStatus(widget.quoteModel.id, RequestStatus.accepted, paymentStatus: payment);
                        paymentSuccessful(
                          context: context,
                          shipmentId: "${widget.quoteModel.bookingId}",
                          isPayment: true,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        );
                      }

                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Text(
                      AppLocalizations.getLocalizationValue(locale, LocaleKey.accept),
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
                child: Text(AppLocalizations.getLocalizationValue(locale, LocaleKey.shipmentDetails), style: style),
              ),
              buildMaterialContainer(size),
              buildTypes(size),
              Container(
                padding: padding,
                child: Text(AppLocalizations.getLocalizationValue(locale, LocaleKey.pickupLocation), style: style),
              ),
              createLocationBlock(size, 0),
              Container(
                padding: padding,
                child: Text(AppLocalizations.getLocalizationValue(locale, LocaleKey.dropLocation), style: style),
              ),
              createLocationBlock(size, 1),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: Container(
                  child: Text(
                    '${widget.quoteModel.insured ? AppLocalizations.getLocalizationValue(locale, LocaleKey.withInsurance) : AppLocalizations.getLocalizationValue(locale, LocaleKey.withOutInsurance)}',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: Text(
                  "${widget.onlyView ? AppLocalizations.getLocalizationValue(locale, widget.quoteModel.paymentStatus) : AppLocalizations.getLocalizationValue(locale, LocaleKey.fare)}:  \u20B9${widget.quoteModel.price} $fineString",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: const Color(0xff76b448),
                    fontWeight: FontWeight.w500,
                    height: 2.142857142857143,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                child: Text(
                  "Advance: $advance",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: const Color(0xff76b448),
                    fontWeight: FontWeight.w500,
                    height: 2.142857142857143,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              if (widget.quoteModel.advance > 0.0 && payment == PaymentType.cod)
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                  child: Text(
                    "Advance payment required of \u20b9${widget.quoteModel.advance}",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              if (!widget.onlyView && payment != null && payment != PaymentType.cod) buildCouponWidget(),
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
                            isCouponApplied = false;
                            coupon = "";
                            if (_couponController != null) {
                              _couponController.text = "";
                            }
                          });
                        },
                      ),
                      Expanded(
                        child: Text(AppLocalizations.getLocalizationValue(locale, PaymentType.cod)),
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
                        child: Text("${AppLocalizations.getLocalizationValue(locale, PaymentType.online)}"),
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
                          "${AppLocalizations.getLocalizationValue(locale, PaymentType.trukMoney)} ${double.parse(widget.quoteModel.price) > pWallet.myWallet.amount ? '(${AppLocalizations.getLocalizationValue(locale, LocaleKey.notEnoughMoney)})' : ''}",
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
                  '${m.quantity} ${m.unit}',
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
          createTypes(
              AppLocalizations.getLocalizationValue(this.locale, LocaleKey.mandateType),
              AppLocalizations.getLocalizationValue(this.locale,
                  widget.quoteModel.mandate.toLowerCase().contains('ondemand') ? LocaleKey.onDemand : LocaleKey.lease)),
          SizedBox(
            height: 10,
          ),
          createTypes(
              AppLocalizations.getLocalizationValue(this.locale, LocaleKey.loadType),
              AppLocalizations.getLocalizationValue(
                  this.locale,
                  widget.quoteModel.load.toLowerCase().contains('partial')
                      ? LocaleKey.partialTruk
                      : LocaleKey.fullTruk)),
          SizedBox(
            height: 10,
          ),
          createTypes(
              AppLocalizations.getLocalizationValue(this.locale, LocaleKey.trukType),
              AppLocalizations.getLocalizationValue(this.locale,
                  widget.quoteModel.truk.toLowerCase().contains('closed') ? LocaleKey.closedTruk : LocaleKey.openTruk)),
        ],
      ),
    );
  }

  Widget buildCouponWidget() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        height: payment != null && payment != PaymentType.cod ? 55 : 0,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _couponController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.getLocalizationValue(locale, LocaleKey.coupon),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: RaisedButton(
                onPressed: () async {
                  String coupon = _couponController.text;
                  if (coupon.isEmpty) {
                    Fluttertoast.showToast(msg: 'Please enter coupon');
                    return;
                  }
                  setState(() {
                    isLoading = true;
                  });
                  CouponModel c = await FirebaseHelper().validateCoupon(coupon);

                  setState(() {
                    isLoading = false;
                  });
                  if (c == null) {
                    Fluttertoast.showToast(
                      msg: 'Invalid Coupon',
                      gravity: ToastGravity.CENTER,
                      backgroundColor: primaryColor,
                      toastLength: Toast.LENGTH_LONG,
                    );
                    return;
                  }

                  if (int.parse(widget.quoteModel.price) < c.minimum) {
                    Fluttertoast.showToast(
                      msg: 'Minimum price is ${c.minimum}',
                      gravity: ToastGravity.CENTER,
                      backgroundColor: primaryColor,
                      toastLength: Toast.LENGTH_LONG,
                    );
                    return;
                  }

                  bool isUsed = await FirebaseHelper().checkCouponUsage(coupon);
                  if (isUsed) {
                    Fluttertoast.showToast(
                      msg: 'Coupon already used',
                      gravity: ToastGravity.CENTER,
                      backgroundColor: primaryColor,
                      toastLength: Toast.LENGTH_LONG,
                    );
                    return;
                  }
                  setState(() {
                    isCouponApplied = true;
                    coupon = c.code.toUpperCase();
                  });
                  double actualPrice = double.parse(widget.quoteModel.price);
                  discountedPrice = actualPrice - (actualPrice * (c.discountPercent / 100));
                  Fluttertoast.showToast(
                    msg: 'Coupon applied! You get discount of \u20B9${actualPrice * (c.discountPercent / 100)}',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: primaryColor,
                    toastLength: Toast.LENGTH_LONG,
                  );
                  print(discountedPrice);
                },
                color: primaryColor,
                child: Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      AppLocalizations.getLocalizationValue(locale, LocaleKey.apply),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
