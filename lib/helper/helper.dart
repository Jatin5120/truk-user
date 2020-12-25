import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
}
