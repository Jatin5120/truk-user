import 'package:flutter/material.dart';
import '../utils/no_data_page.dart';

class MyShipment extends StatefulWidget {
  final Function onAppbarBack;

  const MyShipment({Key key, this.onAppbarBack}) : super(key: key);

  @override
  _MyShipmentState createState() => _MyShipmentState();
}

class _MyShipmentState extends State<MyShipment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Shipments'),
        centerTitle: true,
        leading: InkWell(
          onTap: widget.onAppbarBack,
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: NoDataPage(
        text: 'No Shipment',
      ),
    );
  }
}
