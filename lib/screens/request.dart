import 'package:flutter/material.dart';

import '../utils/constants.dart';

class Request extends StatefulWidget {
  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  TextEditingController pickupLocation = TextEditingController();
  TextEditingController dropLocation = TextEditingController();
  TextEditingController dateOfBooking = TextEditingController();
  TextEditingController material = TextEditingController();

  Widget myCustomTextField(
      {TextEditingController controller, String labelText}) {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20),
      child: Form(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              labelText: labelText, border: OutlineInputBorder()),
        ),
      ),
    );
  }

  Widget myFormField({
    List<DropdownMenuItem<dynamic>> items,
    void Function(dynamic) onChanged,
    String value,
    String labelText,
  }) {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 12),
            labelText: labelText,
            border: OutlineInputBorder()),
        items: items,
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Quote'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            // height: height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                myCustomTextField(labelText: 'Pickup Location'),
                SizedBox(
                  height: 15,
                ),
                myCustomTextField(labelText: 'Drop Location'),
                SizedBox(
                  height: 15,
                ),
                myCustomTextField(labelText: 'Date of Booking'),
                SizedBox(
                  height: 15,
                ),
                myCustomTextField(labelText: 'Material'),
                SizedBox(
                  height: 15,
                ),
                myFormField(
                    labelText: 'Quantity (Kg)',
                    onChanged: (value) {},
                    value: '100',
                    items: ['100'].map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }).toList()),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text('Mandate Type',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                ),
                SizedBox(height: 15),
                myFormField(
                    onChanged: (value) {},
                    value: 'On-Demand',
                    items: ['On-Demand'].map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }).toList()),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text('Load Type',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                ),
                SizedBox(height: 15),
                myFormField(
                    onChanged: (value) {},
                    value: 'Partial Truk',
                    items: ['Partial Truk'].map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e, style: TextStyle(fontSize: 18)),
                      );
                    }).toList()),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text('Truk Type',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                ),
                SizedBox(height: 15),
                myFormField(
                    onChanged: (value) {},
                    value: 'Open Truk',
                    items: [
                      'Open Truk',
                    ].map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e, style: TextStyle(fontSize: 18)),
                      );
                    }).toList()),
                SizedBox(height: 15),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  height: 65,
                  width: width,
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: RaisedButton(
                    visualDensity: VisualDensity.comfortable,
                    color: primaryColor,
                    onPressed: () {},
                    child: Text(
                      'Request Quote',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
