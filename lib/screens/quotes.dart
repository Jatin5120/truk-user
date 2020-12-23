import 'package:flutter/material.dart';

class Quotes extends StatefulWidget {
  @override
  _QuotesState createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  TextStyle style = TextStyle(fontSize: 14, color: Colors.black);
  Widget quotes(
      {String carName,
      String truckType,
      String quantity,
      String truckId,
      String pickupLocation,
      String dateOrdered,
      String fare,
      String loadType,
      String dropLocation}) {
    return Container(
      // height: 80,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Container(
                      child: RichText(
                        text:
                            TextSpan(style: TextStyle(fontSize: 14), children: [
                          TextSpan(
                              text: '$carName ',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: '($truckType) $quantity Kg', style: style)
                        ]),
                      ),
                      padding: EdgeInsets.only(left: 10, right: 0),
                      // child: Text('$carName ($truckType ) $quantity Kg'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 0),
                    child: Text(
                      'Truk ID: $truckId',
                      style: style,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 0),
                    child: Text(
                      '$pickupLocation-$dropLocation',
                      style: style,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FlatButton(
                          onPressed: () {},
                          color: Colors.green,
                          child: Text(
                            'Accept',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        FlatButton(
                          color: Colors.white,
                          onPressed: () {},
                          child: Text(
                            'Reject',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Text('$dateOrdered'),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Text(
                      '$loadType',
                      style: TextStyle(color: Color.fromRGBO(255, 113, 1, 100)),
                    ),
                  ),
                  SizedBox(height: 10),
                  FittedBox(
                      child: Container(
                          padding: EdgeInsets.only(right: 5),
                          child: Text('₹ $fare/-'))),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: FlatButton(
                      color: Colors.blue,
                      onPressed: () {},
                      child: Text(
                        'Chat',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> quote = [
    {
      'carName': 'EICHIER',
      'truckType': 'Closed Truck',
      'quantity': '890',
      'truckId': 'TruK5555566',
      'pickupLocation': 'Kanyakumari',
      'dropLocation': 'Bangalore',
      'dateOrdered': '25/09/2020  09:00AM',
      'fare': '2900-3200',
      'loadType': 'Full Truk'
    },
    {
      'carName': 'TATA ACE',
      'truckType': 'Open Truck',
      'quantity': '890',
      'truckId': 'TruK856785',
      'pickupLocation': 'Udupi-Hubli',
      'dropLocation': 'Bangalore',
      'dateOrdered': '25/09/2020  10:00AM',
      'loadType': 'Partial Truk',
      'fare': '2500-3000'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Quotes'),
        backgroundColor: Color.fromRGBO(255, 113, 1, 100),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: quote.length,
            itemBuilder: (context, index) {
              return quotes(
                  carName: quote[index]['carName'],
                  dropLocation: quote[index]['dropLocation'],
                  pickupLocation: quote[index]['pickupLocation'],
                  fare: quote[index]['fare'],
                  loadType: quote[index]['loadType'],
                  quantity: quote[index]['quantity'],
                  truckId: quote[index]['truckId'],
                  dateOrdered: quote[index]['dateOrdered'],
                  truckType: quote[index]['truckType']);
            }),
      ),
    );
  }
}
