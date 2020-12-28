import 'package:flutter/material.dart';
import 'package:trukapp/utils/no_data_page.dart';

class MyShipment extends StatefulWidget {
  @override
  _MyShipmentState createState() => _MyShipmentState();
}

class _MyShipmentState extends State<MyShipment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shipments'),
      ),
      body: NoDataPage(
        text: 'No Shipment',
      ),
    );
  }
}
