import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import '../firebase_helper/firebase_helper.dart';
import '../models/user_model.dart';
import '../models/wallet_model.dart';
import '../utils/constants.dart';
import '../widgets/money_suggestion_widget.dart';
import '../widgets/widgets.dart';

class TrukMoney extends StatefulWidget {
  @override
  _TrukMoneyState createState() => _TrukMoneyState();
}

class _TrukMoneyState extends State<TrukMoney> with SingleTickerProviderStateMixin {
  static int initialIndex = 0;
  TabController tabController;
  List<String> moneySuggest = ['500', '1000', '2000'];
  int selectedMoney = -1;
  final User user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  Razorpay _razorpay;
  bool isPaymentLoading = false;
  Locale locale;

  createOrder(int amount, String email, String name) async {
    setState(() {
      isPaymentLoading = true;
    });
    var options = {
      'key': 'rzp_test_mJh9QWD7lZ8ToY',
      'amount': amount, //in the smallest currency sub-unit.
      'name': '$name',
      'description': 'Wallet topup',
      'timeout': 300, // in seconds
      'currency': 'INR',
      'prefill': {'contact': '${user.phoneNumber.substring(3)}', 'email': '$email'}
    };
    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    double amount = double.parse(_amountController.text);
    setState(() {
      isPaymentLoading = false;
    });
    FirebaseHelper().updateWallet(response.paymentId, amount, 1).then((v) {
      paymentSuccessful(
        context: context,
        isPayment: true,
        onTap: () {
          Navigator.pop(context);
          _amountController.text = '';
          //Navigator.pop(context);
        },
      );
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
    tabController = TabController(
      initialIndex: initialIndex,
      length: 3,
      vsync: this,
    );
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry padding = EdgeInsets.only(left: 16, right: 16);
    final Size size = MediaQuery.of(context).size;
    final pWallet = Provider.of<MyWallet>(context);
    final pUser = Provider.of<MyUser>(context);
    locale = AppLocalizations.of(context).locale;
    return LoadingOverlay(
      isLoading: isPaymentLoading,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            AppLocalizations.getLocalizationValue(locale, LocaleKey.trukMoney),
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Container(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.getLocalizationValue(locale, LocaleKey.balance),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '₹ ${pWallet.isLoading ? 0 : pWallet.myWallet.amount ?? 0}',
                        style: TextStyle(color: Colors.orange, fontSize: 24),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                // SizedBox(height: 10,),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    AppLocalizations.getLocalizationValue(locale, LocaleKey.topupWallet),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ),
                TextFormField(
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return AppLocalizations.getLocalizationValue(locale, LocaleKey.requiredText);
                    }
                    if (int.parse(value) <= 0) {
                      return '*Invalid amount';
                    }
                    return null;
                  },
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (moneySuggest.any((element) => element != value)) {
                      setState(() {
                        selectedMoney = -1;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.getLocalizationValue(locale, LocaleKey.enterAmount),
                    prefixText: '\u20B9',
                    prefixStyle: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Text(
                    AppLocalizations.getLocalizationValue(locale, LocaleKey.recommended),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: moneySuggest.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: size.width * 0.25,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedMoney = index;
                              _amountController.text = moneySuggest[index];
                            });
                          },
                          child: MoneySuggestion(
                            text: moneySuggest[index],
                            isSelected: selectedMoney == index,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.only(top: 10, bottom: 10),
                //   child: Text(
                //     'Debit From',
                //     style: TextStyle(
                //       color: Colors.grey,
                //       fontSize: 18,
                //     ),
                //   ),
                // ),
                // TabBar(
                //   controller: tabController,
                //   indicatorColor: primaryColor,
                //   indicatorSize: TabBarIndicatorSize.tab,
                //   isScrollable: true,
                //   labelColor: primaryColor,
                //   unselectedLabelColor: Colors.black,
                //   tabs: [
                //     Text(
                //       'BHIM UPI',
                //       style: TextStyle(color: Colors.black, fontSize: 14),
                //     ),
                //     Text(
                //       'DEBIT CARD',
                //       style: TextStyle(color: Colors.black, fontSize: 14),
                //     ),
                //     Text(
                //       'CREDIT CARD',
                //       style: TextStyle(color: Colors.black, fontSize: 14),
                //     )
                //   ],
                // ),
                // Container(
                //   height: 60,
                //   child: TabBarView(
                //     controller: tabController,
                //     children: [
                //       Text('hi'),
                //       Text('hi'),
                //       Text('hi'),
                //     ],
                //   ),
                // ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  width: size.width,
                  padding: const EdgeInsets.only(bottom: 16),
                  child: RaisedButton(
                    color: primaryColor,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        int amount = int.parse(_amountController.text) * 100;
                        await createOrder(amount, pUser.user.email, pUser.user.name);
                        //pWallet.getWalletBalance();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        AppLocalizations.getLocalizationValue(locale, LocaleKey.topupWallet),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
