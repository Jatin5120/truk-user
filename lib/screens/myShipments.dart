import 'package:flutter/material.dart';

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
    );
  }
}
