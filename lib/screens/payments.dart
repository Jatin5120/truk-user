import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int selected;

  Razorpay _razorpay;

  createOrder(double amount) async {
    var options = {
      'key': 'rzp_test_mJh9QWD7lZ8ToY',
      'amount': 500, //in the smallest currency sub-unit.
      'name': 'Test Truk',
      'description': 'Fine T-Shirt',
      'timeout': 60, // in seconds
      'prefill': {'contact': '9123456789', 'email': 'something@example.com'}
    };
    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print("Payment Success : ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("Payment Error : ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    print(response.walletName);
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    selected = 0;
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  Widget paymentCard({String name, int value}) {
    return Container(
      height: 70,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Card(
        elevation: 2.5,
        child: RadioListTile(
            title: Text(name),
            value: value,
            groupValue: selected,
            onChanged: (int value) {
              setState(() {
                selected = value;
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Text(
                'UPI',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            paymentCard(name: 'Amazon Pay UPI', value: 0),
            paymentCard(name: 'Other UPI Apps', value: 1),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'More',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            paymentCard(name: 'Debit Card', value: 2),
            paymentCard(name: 'Credit Card', value: 3),
            paymentCard(name: 'Net Banking', value: 4),
            paymentCard(name: 'Pay on Delivery', value: 5),
            paymentCard(name: 'Wallets', value: 6),
            Container(
              height: 65,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Card(
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              height: 65,
              width: width,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: RaisedButton(
                color: primaryColor,
                onPressed: () async {
                  createOrder(1.00);
                },
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
