import 'package:flutter/material.dart';

void paymentSuccessful({String shipmentId, BuildContext context}) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child:
                  Text('Payment Successful !', style: TextStyle(fontSize: 18))),
          content: IntrinsicHeight(
            child: Column(
              children: [
                Center(
                  child: Image(
                    height: 60,
                    image: AssetImage('assets/images/check_icon.png'),
                  ),
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
          ),
          actions: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: RaisedButton(
                color: Color.fromRGBO(255, 113, 1, 1),
                onPressed: () {},
                child: Text(
                  'Done',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
        );
      });
}
