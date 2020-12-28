import 'package:flutter/material.dart';
import 'package:trukapp/utils/constants.dart';

void paymentSuccessful({String shipmentId, BuildContext context, bool isPayment = true, Function onTap}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: isPayment ? 2 : 30,
            ),
            Center(
              child: Text(
                isPayment ? 'Payment Successful!' : 'Booking Requested!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: isPayment ? 2 : 30,
            ),
            Center(
              child: Image.asset(
                'assets/images/${isPayment ? "check_icon" : "request_success"}.png',
                height: isPayment ? 60 : 113,
                width: isPayment ? 60 : 155,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: isPayment ? 15 : 50,
            ),
            shipmentId == null
                ? Container()
                : Text(
                    'Shipment ID: $shipmentId',
                    style: TextStyle(fontSize: 18),
                  )
          ],
        ),
        actions: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: RaisedButton(
              color: primaryColor,
              onPressed: onTap,
              child: Text(
                'Done',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
        ],
      );
    },
  );
}
