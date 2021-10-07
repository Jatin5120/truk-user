import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import 'package:trukapp/screens/tcPage.dart';
import '../firebase_helper/firebase_helper.dart';
import '../helper/helper.dart';

import '../models/material_model.dart';
import '../screens/home.dart';
import '../utils/constants.dart';
import '../widgets/widgets.dart';

class ShipmentSummary extends StatefulWidget {
  final List<MaterialModel> materials;
  final LatLng source;
  final LatLng destination;
  final String pickupDate;
  final String mandateType;
  final String loadType;
  final String trukType;
  const ShipmentSummary({
    Key key,
    @required this.materials,
    @required this.source,
    @required this.destination,
    @required this.pickupDate,
    @required this.mandateType,
    @required this.loadType,
    @required this.trukType,
  }) : super(key: key);

  @override
  _ShipmentSummaryState createState() => _ShipmentSummaryState();
}

class _ShipmentSummaryState extends State<ShipmentSummary> {
  bool isLoading = false;
  String sourceAddress = '';
  String destinationAddress = '';
  bool isInsured;
  Locale locale;

  @override
  void initState() {
    super.initState();
    Helper()
        .setLocationText(widget.source)
        .then((value) => setState(() => sourceAddress = value));
    Helper()
        .setLocationText(widget.destination)
        .then((value) => setState(() => destinationAddress = value));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final EdgeInsetsGeometry padding =
        EdgeInsets.only(left: 16, right: 16, top: 20);
    final TextStyle style =
        TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    locale = AppLocalizations.of(context).locale;
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.getLocalizationValue(
              this.locale, LocaleKey.shipmentSummary)),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            height: 60,
            width: size.width,
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
              ),
              onPressed: () async {
                if (isInsured == null) {
                  Fluttertoast.showToast(
                      msg: AppLocalizations.getLocalizationValue(
                          this.locale, LocaleKey.selectInsurance));
                  return;
                }

                setState(() {
                  isLoading = true;
                });
                String id = await FirebaseHelper().insertRequest(
                  pickupDate: widget.pickupDate,
                  materials: widget.materials,
                  source: widget.source,
                  destination: widget.destination,
                  trukType: widget.trukType,
                  loadType: widget.loadType,
                  mandateType: widget.mandateType,
                  isInsured: isInsured,
                );
                setState(() {
                  isLoading = false;
                });
                paymentSuccessful(
                  context: context,
                  shipmentId: "$id",
                  isPayment: false,
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                );
              },
              child: Text(
                AppLocalizations.getLocalizationValue(
                    this.locale, LocaleKey.requestButton),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
        body: Container(
          child: ListView(
            children: [
              Container(
                padding: padding,
                child: Text(
                    AppLocalizations.getLocalizationValue(
                        this.locale, LocaleKey.shipmentDetails),
                    style: style),
              ),
              buildMaterialContainer(size),
              buildTypes(size),
              Container(
                padding: padding,
                child: Text(
                    AppLocalizations.getLocalizationValue(
                        this.locale, LocaleKey.pickupLocation),
                    style: style),
              ),
              createLocationBlock(size, 0),
              Container(
                padding: padding,
                child: Text(
                    AppLocalizations.getLocalizationValue(
                        this.locale, LocaleKey.dropLocation),
                    style: style),
              ),
              createLocationBlock(size, 1),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 16),
                child: Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: isInsured,
                      onChanged: (b) {
                        setState(() {
                          isInsured = b;
                        });
                      },
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: AppLocalizations.getLocalizationValue(
                                  this.locale, LocaleKey.insuranceText1),
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text:
                                  "${AppLocalizations.getLocalizationValue(this.locale, LocaleKey.insuranceText2)}",
                              style: TextStyle(
                                color: primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => TCPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 16),
                child: Row(
                  children: [
                    Radio(
                      value: false,
                      groupValue: isInsured,
                      onChanged: (b) {
                        setState(() {
                          isInsured = b;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(AppLocalizations.getLocalizationValue(
                          this.locale, LocaleKey.no)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMaterialContainer(Size size) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: const Color(0xfff8f8f8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.materials.length,
        itemBuilder: (context, index) {
          MaterialModel m = widget.materials[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  '${index + 1}. ',
                  style: TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Expanded(
                  child: Text(
                    '${m.materialName}',
                    style: TextStyle(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '${m.quantity} KG',
                  style: TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildTypes(Size size) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: const Color(0xfff8f8f8),
      ),
      child: Column(
        children: [
          createTypes(
              AppLocalizations.getLocalizationValue(
                  this.locale, LocaleKey.mandateType),
              AppLocalizations.getLocalizationValue(
                  this.locale,
                  widget.mandateType.toLowerCase().contains('ondemand')
                      ? LocaleKey.onDemand
                      : LocaleKey.lease)),
          SizedBox(
            height: 10,
          ),
          createTypes(
              AppLocalizations.getLocalizationValue(
                  this.locale, LocaleKey.loadType),
              AppLocalizations.getLocalizationValue(
                  this.locale,
                  widget.loadType.toLowerCase().contains('partial')
                      ? LocaleKey.partialTruk
                      : LocaleKey.fullTruk)),
          SizedBox(
            height: 10,
          ),
          createTypes(
              AppLocalizations.getLocalizationValue(
                  this.locale, LocaleKey.trukType),
              AppLocalizations.getLocalizationValue(
                  this.locale,
                  widget.trukType.toLowerCase().contains('closed')
                      ? LocaleKey.closedTruk
                      : LocaleKey.openTruk)),
        ],
      ),
    );
  }

  Widget createTypes(String heading, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$heading',
            style: TextStyle(fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          '$value',
          style: TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget createLocationBlock(Size size, int type) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10),
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: const Color(0xfff8f8f8),
      ),
      child: Text(
        type == 0 ? sourceAddress : destinationAddress,
      ),
    );
  }
}
