import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  Widget notificationWidget({String time, String notification}) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$time',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            flex: 0,
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 0.2,
              child: Container(
                padding: EdgeInsets.only(bottom: 10, left: 5, top: 5),
                width: width,
                child: Text(
                  '$notification',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Container(
        child: ListView(
          // shrinkWrap: true,
          children: [
            SizedBox(
              height: 20,
            ),
            notificationWidget(
                time: '5 Min ago',
                notification:
                    'Your shipment from Bangalor to Mangalore delivered successfully'),
            notificationWidget(
                time: '1 Hour ago',
                notification:
                    'Your Quote request value is 2,500/- book your shipment soon'),
            notificationWidget(
                time: '1 Day ago',
                notification: 'Your payment successful of 3,200/-')
          ],
        ),
      ),
    );
  }
}
