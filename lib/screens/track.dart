import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trukapp/firebase_helper/firebase_helper.dart';
import 'package:trukapp/helper/helper.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import 'package:trukapp/models/shipment_model.dart';
class TrackNew extends StatefulWidget {
  final ShipmentModel shipmentModel;
  TrackNew({
    @required this.shipmentModel
  });
  @override
  _TrackNewState createState() => _TrackNewState();
}

class _TrackNewState extends State<TrackNew> {
  String source;
  String dest;
  List<String> positions =[];
  List<dynamic> timing=[];
  Locale locale;
  bool isLoading = true;

  List locationHistory = [];

  getData() async {
    String s = await Helper().setLocationText(widget.shipmentModel.source);
    String d = await Helper().setLocationText(widget.shipmentModel.destination);
    setState(() {
      source = s;
      dest = d;
    });
    await FirebaseFirestore.instance.collection(FirebaseHelper.driverCollection).doc(widget.shipmentModel.driver).collection(widget.shipmentModel.id).get().then((value) async {
      for(var d in value.docs){
        String ln = d['position'];
        List<String> splitted = ln.split(',');
        LatLng ltln = LatLng(double.parse(splitted[0]), double.parse(splitted[1]));
        String p = await Helper().setLocationText(ltln);
        setState(() {
          positions.add(p);
          timing.add(d['time']);
          locationHistory.add(Locations(position: p,time: d['time']));
        });
      }
    });
    setState(() {
      isLoading=false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    locale = AppLocalizations.of(context).locale;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.getLocalizationValue(locale, LocaleKey.trackShipment)),
      ),
      body: isLoading?Center(child: CircularProgressIndicator()):Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey[300],
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Source:"
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          source
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey[300],
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Destination:"
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          dest
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey[300],
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Last Location:"
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          positions.isNotEmpty?positions[positions.length-1]:"No Location Update Available"
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey[300],
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Last Update on:"
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          timing.isNotEmpty?(timing[timing.length-1]).toString():"No Update Available"
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(8.0),
              child:Text('Location History',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),)
            ),
            Expanded(
              child: ListView.builder(
                itemCount: locationHistory.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(padding: EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.grey[300],
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Row(
                          children: [
                            Text('Time :- '),
                            Text('${locationHistory[index].time}')
                          ],
                        ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text('Address :- '),
                              Text('${locationHistory[index].position}')
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },),
            )
          ],
        ),
      ),
    );
  }
}


class Locations{
  String position;
  String time;
  Locations({this.position,this.time});
}