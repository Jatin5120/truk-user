import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trukapp/firebase_helper/firebase_helper.dart';
import 'package:trukapp/helper/helper.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import 'package:trukapp/models/shipment_model.dart';
import 'package:trukapp/utils/constants.dart';
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
      locationHistory = locationHistory.reversed.toList();
    });

  }
  @override
  void initState() {
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
      body: isLoading?Center(child: CircularProgressIndicator()):SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: size.height,
          width: size.width,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  // color: Colors.grey[300],
                  border: Border.all(color: primaryColor,width: 2),
                  borderRadius: BorderRadius.circular(12)
                ),
                padding: EdgeInsets.all(16),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        "Source:"
                    ),
                    SizedBox(height: 8,),
                    Text(
                        source
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: primaryColor,width: 2),
                    borderRadius: BorderRadius.circular(12)
                ),
                padding: EdgeInsets.all(16),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Destination:"
                    ),
                    SizedBox(height: 8,),
                    Text(
                        dest
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  // color: Colors.grey[300],
                    color: primaryColor.withOpacity(0.15),
                    //   border: Border.all(color: primaryColor,width: 2),
                    borderRadius: BorderRadius.circular(12)
                ),
                padding: EdgeInsets.all(16),              width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Last Location:"
                    ),
                    SizedBox(height: 8,),
                    Text(
                        positions.isNotEmpty?positions[positions.length-1]:"No Location Update Available"
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  // color: Colors.grey[300],
                    color: primaryColor.withOpacity(0.15),
                    //   border: Border.all(color: primaryColor,width: 2),
                    borderRadius: BorderRadius.circular(12)
                ),
                padding: EdgeInsets.all(16),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Last Update on:"
                    ),
                    SizedBox(height: 8,),
                    Text(
                        timing.isNotEmpty? Helper.formateDate(timing[timing.length-1])  :"No Update Available"
                        // timing.isNotEmpty?(timing[timing.length-1]).toString():"No Update Available"
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(8.0),
                child:Text('Location History',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),)
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: locationHistory.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        // color: Colors.grey[300],
                          color: primaryColor.withOpacity(0.15),
                            border: Border.all(color: primaryColor,width: 2),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text('${Helper.formateDate(locationHistory[index].time)}'),
                          SizedBox(height: 10,),
                          Text('${locationHistory[index].position}',overflow: TextOverflow.ellipsis,)
                        ],
                      ),
                    );
                  },),
              )
            ],
          ),
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