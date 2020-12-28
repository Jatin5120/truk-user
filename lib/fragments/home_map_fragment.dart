import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../screens/matDetails.dart';
import '../sessionmanagement/session_manager.dart';
import '../utils/constants.dart';

class HomeMapFragment extends StatefulWidget {
  @override
  _HomeMapFragmentState createState() => _HomeMapFragmentState();
}

class _HomeMapFragmentState extends State<HomeMapFragment> with AutomaticKeepAliveClientMixin {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  final _sourceTextController = TextEditingController();
  final _destinationTextController = TextEditingController();

  bool isLoading = true;
  final Permission _permission = Permission.location;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  GoogleMapController mapController;

  LatLng myLatLng;
  Map<String, Marker> myMarker = {};

  @override
  void initState() {
    super.initState();
    _checkGps().then((value) async {
      if (value) {
        _listenForPermissionStatus();
        if (_permissionStatus != PermissionStatus.granted) {
          await requestPermission(_permission);
        }
        if (_permissionStatus == PermissionStatus.granted) _getLocation(context);
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    CameraUpdate c = CameraUpdate.newLatLngZoom(myLatLng, 16);
    mapController.animateCamera(c);
    myMarker.clear();

    setState(() {});
  }

  Future _checkGps() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("GPS disabled"),
              content: const Text('Please make sure you enable GPS and try again'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    final intent = AndroidIntent(action: 'android.settings.LOCATION_SOURCE_SETTINGS');

                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      return null;
    }
    return true;
  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _permissionStatus = status);
  }

  _getLocation(context) async {
    bool s = await _checkGps() ?? false;
    if (!s) {
      Fluttertoast.showToast(msg: "Please enable GPS to proceed");
      return;
    }
    setState(() {
      isLoading = true;
    });
    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    final lat = pos.latitude;
    final lng = pos.longitude;
    if (pos != null) {
      myLatLng = LatLng(lat, lng);
      await SharedPref().createLocationData(lat, lng);
    }
    isLoading = false;
    if (mounted) setState(() {});
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }

  Future setLocationText(int type) async {
    LatLng latLng = myMarker[type == 0 ? 'source' : 'destination'].position;
    final coordinates = Coordinates(latLng.latitude, latLng.longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    String street = address.first.featureName;
    String area = address.first.subLocality;
    String pincode = address.first.postalCode;
    String city = address.first.subAdminArea;
    String state = address.first.adminArea;
    if (type == 0) {
      _sourceTextController.text = '$street, $area, $city';
    } else {
      _destinationTextController.text = '$street, $area, $city';
    }

    setState(() {});
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: [
          isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Getting your location"),
                      SizedBox(height: 10),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      )
                    ],
                  ),
                )
              : GoogleMap(
                  markers: myMarker.values.toSet(),
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: myLatLng,
                    zoom: 11.0,
                  ),
                  padding: EdgeInsets.only(
                    top: height * 0.4,
                  ),
                  zoomGesturesEnabled: true,
                  onTap: (latlng) async {
                    int count = myMarker.length;
                    if (count == 0) {
                      myMarker['source'] = Marker(
                        markerId: MarkerId('source'),
                        position: latlng,
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                        infoWindow: InfoWindow(title: 'Source'),
                      );
                      await setLocationText(0);
                    } else if (count == 1) {
                      myMarker['destination'] = Marker(
                        markerId: MarkerId('destination'),
                        position: latlng,
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                        infoWindow: InfoWindow(title: 'destination'),
                      );
                      await setLocationText(1);
                    } else {
                      myMarker.clear();
                      myMarker['source'] = Marker(
                        markerId: MarkerId('source'),
                        position: latlng,
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                        infoWindow: InfoWindow(title: 'Source'),
                      );
                      await setLocationText(0);
                    }
                    setState(() {});
                  },
                ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: Column(
              children: [
                Container(
                  width: width,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    elevation: 12.0,
                    child: TextFormField(
                      controller: _sourceTextController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10, top: 15),
                        prefixIcon: Icon(
                          Icons.map,
                        ),
                        alignLabelWithHint: false,
                        hintText: 'Enter Pick Up Location',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: width,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    elevation: 12.0,
                    child: TextFormField(
                      controller: _destinationTextController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10, top: 15),
                        prefixIcon: Icon(
                          Icons.pin_drop,
                        ),
                        alignLabelWithHint: false,
                        hintText: 'Enter Drop Location',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              height: 65,
              width: width,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: RaisedButton(
                visualDensity: VisualDensity.comfortable,
                color: primaryColor,
                onPressed: () {
                  bool isSourceEmpty = myMarker['source'] == null;
                  bool isDestinationEmpty = myMarker['destination'] == null;
                  if (isSourceEmpty || isDestinationEmpty) {
                    Fluttertoast.showToast(msg: 'Please give source and destination of shipment');
                    return;
                  }
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => MaterialDetails(
                        source: myMarker['source'].position,
                        destination: myMarker['destination'].position,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Continue Booking',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
