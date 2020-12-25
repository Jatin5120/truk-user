import 'package:flutter/material.dart';

class MyShipment extends StatefulWidget {
  @override
  _MyShipmentState createState() => _MyShipmentState();
}

class _MyShipmentState extends State<MyShipment> with AutomaticKeepAliveClientMixin {
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shipments'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
