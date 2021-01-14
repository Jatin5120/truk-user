import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/helper/helper.dart';
import 'package:trukapp/helper/request_status.dart';
import 'package:trukapp/models/material_model.dart';
import 'package:trukapp/models/quote_model.dart';
import 'package:trukapp/models/shipment_model.dart';
import 'package:trukapp/screens/quote_summary_screen.dart';

class ExpandableCardContainer extends StatefulWidget {
  final ShipmentModel model;
  final String docID;
  final bool isCollapsed;

  const ExpandableCardContainer({Key key, this.model, this.docID, this.isCollapsed = false}) : super(key: key);

  @override
  _ExpandableCardContainerState createState() => _ExpandableCardContainerState();
}

class _ExpandableCardContainerState extends State<ExpandableCardContainer> {
  final BoxDecoration enabledDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(5.0),
    color: const Color(0xffff7101),
    boxShadow: [
      BoxShadow(
        color: const Color(0x99ff7101),
        offset: Offset(0, 3),
        blurRadius: 10,
      ),
    ],
  );
  final BoxDecoration disabledBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(5.0),
    border: Border.all(width: 1.0, color: const Color(0xffbfbfbf)),
  );
  final enabledTextStyle = TextStyle(color: Colors.white);
  final disabledTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    color: const Color(0xffbfbfbf),
    fontWeight: FontWeight.w500,
    height: 1.5625,
  );

  @override
  Widget build(BuildContext context) {
    QuoteModel quoteModel = QuoteModel.fromMap(widget.model.toMap());
    double weight = 0;
    for (MaterialModel val in widget.model.materials) {
      weight += val.quantity;
    }

    return Card(
      elevation: 8,
      child: ExpandablePanel(
        header: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15),
                          child: Image.asset(
                            'assets/images/delivery_truck.png',
                            height: 50,
                          ),
                        ),
                        Text(
                          "Order: ${widget.model.bookingId}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quantity: $weight KG",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      FutureBuilder<String>(
                          future: Helper().setLocationText(widget.model.destination),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text('Address...');
                            }
                            return Text(
                              "Destination: ${snapshot.data.split(',')[1].trimLeft()}",
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            );
                          }),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Date: ${widget.model.pickupDate}",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Fare \u20B9 ${widget.model.price}",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        //collapsed: ,
        expanded: Container(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => QuoteSummaryScreen(
                                quoteModel: quoteModel,
                                onlyView: true,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: const Color(0xffff7101),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x99ff7101),
                                offset: Offset(0, 3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Order Summary',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 40.0,
                        decoration:
                            widget.model.status == RequestStatus.started ? enabledDecoration : disabledBoxDecoration,
                        child: Center(
                          child: Text(
                            'Track',
                            style: widget.model.status == RequestStatus.started ? enabledTextStyle : disabledTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
