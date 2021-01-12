import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../helper/date_extension.dart';

class Helper {
  Future<String> setLocationText(LatLng value) async {
    LatLng latLng = value;
    final coordinates = Coordinates(latLng.latitude, latLng.longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    String street = address.first.featureName;
    String area = address.first.subLocality;
    String pincode = address.first.postalCode;
    String city = address.first.subAdminArea;
    String state = address.first.adminArea;
    return '$street, $area, $city, $state, $pincode';
  }

  static LatLng stringToLatlng(String coordindates) {
    List<String> splitted = coordindates.split(',');
    return LatLng(double.parse(splitted[0]), double.parse(splitted[1]));
  }

  String getFormattedDate(int milliseconds) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    bool isToday = date.isSameDate(DateTime.now());
    DateFormat formatter = DateFormat(isToday ? "hh:mm a" : "dd MMM, yyyy");
    return formatter.format(date);
  }
}
