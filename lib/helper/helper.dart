import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:trukapp/utils/constants.dart';

import '../helper/date_extension.dart';

class Helper {
  Future<String> setLocationText(LatLng value) async {
    LatLng latLng = value;
    try {
      final coordinates = Coordinates(latLng.latitude, latLng.longitude);

      var address = await Geocoder.google(kGoogleApiKey).findAddressesFromCoordinates(coordinates);
      String street = address.first.featureName;
      String area = address.first.subLocality;
      String pincode = address.first.postalCode;
      String city = address.first.subAdminArea;
      String state = address.first.adminArea;
      return '$street, $area, $city, $state, $pincode';
    } catch (e) {
      return 'Error';
    }
  }

  static LatLng stringToLatlng(String coordindates) {
    List<String> splitted = coordindates.split(',');
    return LatLng(double.parse(splitted[0]), double.parse(splitted[1]));
  }

  String getFormattedDate(int milliseconds) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    bool isToday = date.isSameDate(DateTime.now());
    DateFormat formatter = DateFormat(isToday ? "hh:mm a" : "dd MMM, yyyy hh:mm a");
    return formatter.format(date);
  }

 static String formateDate(String date){
     var removeSpace = date.split(' ');
     return removeSpace.first+', ' + removeSpace.last.split('.').first.substring(0,5);
 //    return DateFormat('yyyy-MM-dd HH:mm').parse(date).toString();
  }

}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  @override
  String toString() => 'Debouncer(milliseconds: $milliseconds, action: $action, _timer: $_timer)';
}


