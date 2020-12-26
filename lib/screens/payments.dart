import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/screens/addCard.dart';

import '../utils/constants.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int selected;
  @override
  void initState() {
    super.initState();
    selected = 0;
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
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddCard()));
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              height: 65,
              width: width,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: RaisedButton(
                color: primaryColor,
                onPressed: () {
                  // Navigator.of(context).pushReplacement(CupertinoPageRoute(
                  //   builder: (context) => HomeScreen(),
                  // ));
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
