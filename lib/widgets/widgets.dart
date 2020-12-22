import 'package:flutter/material.dart';

Widget paymentSuccessful({String shipmentId, BuildContext context}) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Payment Successful !', style: TextStyle(fontSize: 18)),
          content: Column(
            children: [
              Image(
                image: AssetImage('assets/images/check_icon.png'),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Text(
                  'Shipment ID: $shipmentId',
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: RaisedButton(
                color: Color.fromRGBO(255, 113, 1, 100),
                onPressed: () {},
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
        );
      });
}
