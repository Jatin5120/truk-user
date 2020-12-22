import 'package:flutter/material.dart';

class Promotion extends StatefulWidget {
  @override
  _PromotionState createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promotions'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              width: width,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(133, 45, 145, 1),
                  borderRadius: BorderRadius.circular(5)),
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      'Enjoy 10% off\non your first shipment.',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Text(
                        '10 %\nOFF',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 0,
              child: Image(
                image: AssetImage('assets/images/promotion.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
