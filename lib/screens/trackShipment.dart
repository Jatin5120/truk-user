import 'package:flutter/material.dart';
import 'package:trukapp/helper/helper.dart';
import 'package:trukapp/models/shipment_model.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:trukapp/utils/constants.dart';

class TrackShipment extends StatefulWidget {
  TrackShipment({this.shipmentModel, this.weight});
  final ShipmentModel shipmentModel;
  final String weight;
  @override
  _TrackShipmentState createState() => _TrackShipmentState();
}

class _TrackShipmentState extends State<TrackShipment> {
  List dates = ['22 Aug', '23 Aug', '24 Aug'];
  String currentDate = '22 Aug';
  ScrollController _scrollController;
  final int currentMonth = DateTime.now().month;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Shipment'),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                padding: EdgeInsets.all(10),
                child: Card(
                  elevation: 3.5,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/no_data.png',
                          height: 80,
                          width: 80,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Container(
                                child: Text(
                                    'Shipment ID: ${widget.shipmentModel.bookingId}'),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Text('Quantity: ${widget.weight} Kg'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FutureBuilder<String>(
                                future: Helper().setLocationText(
                                    widget.shipmentModel.destination),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text('Address...');
                                  }
                                  return Text(
                                    "Destination: ${snapshot.data.split(',')[1].trimLeft()}",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 100,
                width: size.width,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: dates.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TimelineTile(
                      axis: TimelineAxis.horizontal,
                      alignment: TimelineAlign.center,
                      isFirst: index == 0,
                      isLast: index == dates.length - 1,
                      beforeLineStyle: LineStyle(color: primaryColor),
                      indicatorStyle: IndicatorStyle(
                        color: dates[index] == '22 Aug'
                            ? primaryColor
                            : Colors.black,
                        indicator: Container(
                          height: dates[index] == '22 Aug' ? 5 : 10,
                          width: dates[index] == '22 Aug' ? 5 : 10,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: dates[index] == '22 Aug'
                                      ? primaryColor
                                      : Colors.black,
                                  blurRadius: 1,
                                  spreadRadius: 2,
                                ),
                              ],
                              shape: BoxShape.circle,
                              color: dates[index] == '22 Aug'
                                  ? primaryColor
                                  : Colors.black),
                        ),
                      ),
                      endChild: Container(
                        constraints: const BoxConstraints(minWidth: 100),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            Text('Mysore'),
                            SizedBox(
                              height: 3,
                            ),
                            Center(
                              child: Text(
                                dates[index],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
