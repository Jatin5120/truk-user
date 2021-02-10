import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart' as places;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import '../screens/matDetails.dart';
import '../sessionmanagement/session_manager.dart';
import '../utils/constants.dart';
import 'package:google_maps_webservice/places.dart';

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
  places.Mode _mode = places.Mode.overlay;
  LatLng myLatLng;
  Map<String, Marker> myMarker = {};
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  var locale;

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

  @override
  void dispose() {
    mapController.dispose();
    _sourceTextController.dispose();
    _destinationTextController.dispose();
    _places.dispose();

    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    CameraUpdate c = CameraUpdate.newLatLngZoom(myLatLng, 16);
    mapController.animateCamera(c);
    //

    setState(() {});
  }

  Future _checkGps() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (BuildContext _) {
            locale = AppLocalizations.of(_).locale;
            return AlertDialog(
              title: Text(AppLocalizations.getLocalizationValue(locale, LocaleKey.gpsDisabled)),
              content: Text(AppLocalizations.getLocalizationValue(locale, LocaleKey.gpsDisableMsg)),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    final intent = AndroidIntent(action: 'android.settings.LOCATION_SOURCE_SETTINGS');

                    intent.launch();
                    Navigator.of(_, rootNavigator: true).pop();
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
      Fluttertoast.showToast(msg: AppLocalizations.getLocalizationValue(locale, LocaleKey.gpsDisableError));
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
      myMarker.clear();
      myMarker['source'] = Marker(
        markerId: MarkerId('source'),
        position: myLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: 'Source'),
      );

      setLocationText(0);
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
      _sourceTextController.text = '$street, $area, $city, $pincode';
    } else {
      _destinationTextController.text = '$street, $area, $city, $pincode';
    }

    //setState(() {});
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    locale = AppLocalizations.of(context).locale;
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
                      Text(AppLocalizations.getLocalizationValue(locale, LocaleKey.gettingLocation)),
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
                  zoomControlsEnabled: false,
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
                      onTap: () async {
                        Prediction p = await places.PlacesAutocomplete.show(
                          context: context,
                          apiKey: kGoogleApiKey,
                          mode: _mode, // Mode.fullscreen
                          language: locale.languageCode,
                          components: [
                            Component(Component.country, 'in'),
                          ],
                        );
                        if (p == null) {
                          return;
                        }
                        if (p != null) {
                          _sourceTextController.text = p.description;
                          PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
                          double lat = detail.result.geometry.location.lat;
                          double lng = detail.result.geometry.location.lng;
                          myMarker['source'] = Marker(
                            markerId: MarkerId('source'),
                            position: LatLng(lat, lng),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                            infoWindow: InfoWindow(title: 'Source'),
                          );
                          CameraUpdate c = CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16);
                          mapController.animateCamera(c);
                          setState(() {});
                        }
                      },
                      controller: _sourceTextController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10, top: 15),
                        prefixIcon: Icon(
                          Icons.map,
                        ),
                        alignLabelWithHint: false,
                        hintText: AppLocalizations.getLocalizationValue(locale, LocaleKey.enterPickup),
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
                      onTap: () async {
                        Prediction p = await places.PlacesAutocomplete.show(
                          context: context,
                          apiKey: kGoogleApiKey,
                          mode: _mode, // Mode.fullscreen
                          language: locale.languageCode,
                          components: [
                            Component(Component.country, 'in'),
                          ],
                        );
                        if (p == null) {
                          return;
                        }
                        if (p != null) {
                          _destinationTextController.text = p.description;
                          PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
                          double lat = detail.result.geometry.location.lat;
                          double lng = detail.result.geometry.location.lng;
                          myMarker['destination'] = Marker(
                            markerId: MarkerId('destination'),
                            position: LatLng(lat, lng),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                            infoWindow: InfoWindow(title: 'Destination'),
                          );
                          CameraUpdate c = CameraUpdate.newLatLngZoom(LatLng(lat, lng), 16);
                          mapController.animateCamera(c);
                          setState(() {});
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 10, top: 15),
                        prefixIcon: Icon(
                          Icons.pin_drop,
                        ),
                        alignLabelWithHint: false,
                        hintText: AppLocalizations.getLocalizationValue(locale, LocaleKey.enterDrop),
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
                  //BlocProvider.of<LanguageBloc>(context)..add(LanguageSelected(Language(SharedPref.en)));
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
                  AppLocalizations.getLocalizationValue(locale, LocaleKey.continueBooking),
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
