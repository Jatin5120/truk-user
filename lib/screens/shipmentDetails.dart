import 'package:flutter/material.dart';

class MyShipment extends StatefulWidget {
  @override
  _MyShipmentState createState() => _MyShipmentState();
}

class _MyShipmentState extends State<MyShipment> {
  Widget details(
      {Map<String, dynamic> materials,
      String mandateType,
      String loadType,
      String truckType}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: materials.keys.toList().map((e) {
                  return Text('Material $e');
                }).toList(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: materials.values.toList().map((e) {
                  return Text('$e Kg');
                }).toList(),
              )
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mandate Type'),
                  Text('Load Type'),
                  Text('Truck Type')
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$mandateType'),
                  Text('$loadType'),
                  Text('$truckType')
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final EdgeInsetsGeometry padding = EdgeInsets.only(left: 20, right: 20);
    final TextStyle style =
        TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shipments'),
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              padding: padding,
              child: Text('Shipment Details', style: style),
            ),
          ],
        ),
      ),
    );
  }
}
