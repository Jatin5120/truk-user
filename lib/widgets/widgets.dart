import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import '../utils/constants.dart';

void paymentSuccessful(
    {String shipmentId,
      BuildContext context,
      bool isPayment = true,
      Function onTap}) {
  final locale = AppLocalizations.of(context).locale;
  Platform.isAndroid
      ? showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: isPayment ? 2 : 30,
            ),
            Center(
              child: Text(
                isPayment
                    ? AppLocalizations.getLocalizationValue(
                    locale, LocaleKey.paymentSuccess)
                    : AppLocalizations.getLocalizationValue(
                    locale, LocaleKey.bookingRequested),
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: isPayment ? 2 : 30,
            ),
            Center(
              child: Image.asset(
                'assets/images/${isPayment ? "check_icon" : "request_success"}.png',
                height: isPayment ? 60 : 113,
                width: isPayment ? 60 : 155,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: isPayment ? 15 : 50,
            ),
            shipmentId == null
                ? Container()
                : Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text(
                '${AppLocalizations.getLocalizationValue(locale, LocaleKey.shipmentId)}: $shipmentId',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
        actions: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: RaisedButton(
              color: primaryColor,
              onPressed: onTap,
              child: Text(
                AppLocalizations.getLocalizationValue(
                    locale, LocaleKey.done),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
        ],
      );
    },
  )
      : showCupertinoDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: CupertinoAlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: isPayment ? 2 : 30,
              ),
              Center(
                child: Text(
                  isPayment
                      ? AppLocalizations.getLocalizationValue(
                      locale, LocaleKey.paymentSuccess)
                      : AppLocalizations.getLocalizationValue(
                      locale, LocaleKey.bookingRequested),
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: isPayment ? 2 : 30,
              ),
              Center(
                child: Image.asset(
                  'assets/images/${isPayment ? "check_icon" : "request_success"}.png',
                  height: isPayment ? 60 : 113,
                  width: isPayment ? 60 : 155,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: isPayment ? 15 : 50,
              ),
              shipmentId == null
                  ? Container()
                  : Text(
                '${AppLocalizations.getLocalizationValue(locale, LocaleKey.shipmentId)}: $shipmentId',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          actions: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: RaisedButton(
                color: primaryColor,
                onPressed: onTap,
                child: Text(
                  AppLocalizations.getLocalizationValue(
                      locale, LocaleKey.done),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

void showConfirmationDialog(
    {BuildContext context,
      String title,
      String subTitle,
      Function onTap,
      Function onNoTap}) {
  if (onNoTap == null) {
    onNoTap = () {
      Navigator.pop(context);
    };
  }
  final locale = AppLocalizations.of(context).locale;
  Platform.isAndroid
      ? showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('$title'),
      content: Text('$subTitle'),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            onTap();
          },
          child: Center(
            child: Text(
              AppLocalizations.getLocalizationValue(
                  locale, LocaleKey.yes),
              style: TextStyle(color: primaryColor),
            ),
          ),
        ),
        RaisedButton(
          color: primaryColor,
          onPressed: () => Navigator.pop(context),
          child: Center(
            child: Text(
              AppLocalizations.getLocalizationValue(locale, LocaleKey.no),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  )
      : showCupertinoDialog(
    context: context,
    builder: (context) => Material(
      color: Colors.transparent,
      child: CupertinoAlertDialog(
        title: Text('$title'),
        content: Text('$subTitle'),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              onTap();
            },
            child: Center(
              child: Text(
                AppLocalizations.getLocalizationValue(
                    locale, LocaleKey.yes),
                style: TextStyle(color: primaryColor),
              ),
            ),
          ),
          FlatButton(
            onPressed: onNoTap,
            child: Center(
              child: Text(
                AppLocalizations.getLocalizationValue(
                    locale, LocaleKey.no),
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void reasonDialog({
  BuildContext context,
  String title,
  Function(String) onTap,
  String price,
}) {
  final TextEditingController textEditingController = TextEditingController();
  final locale = AppLocalizations.of(context).locale;

  double cancellationCharges = double.parse(price) * 0.1;
  cancellationCharges = cancellationCharges > 1000 ? 1000 : cancellationCharges;

  final List<Widget> actions = [
    OutlinedButton(
      style: OutlinedButton.styleFrom(primary: primaryColor),
      onPressed: () {
        if (textEditingController.text.trim().isEmpty) {
          Fluttertoast.showToast(msg: "Please specify reason");
          return;
        }
        Navigator.pop(context);
        onTap(textEditingController.text.trim());
      },
      child: Center(
        child: Text(
          AppLocalizations.getLocalizationValue(locale, LocaleKey.continueText),
          style: TextStyle(color: Colors.red),
        ),
      ),
    ),
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: primaryColor,
      ),
      onPressed: () => Navigator.pop(context),
      child: Center(
        child: Text(
          AppLocalizations.getLocalizationValue(locale, LocaleKey.cancel),
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  ];

  Widget getContent() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (price != null) ...[
            Text(
              "Note: If the driver has been assigned to the shipment, by cancelling the shipment you'll be charged 10% of the decided shipment amount as cancellation fee.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Charges :- $cancellationCharges",
              style: TextStyle(
                  color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
          ],
          ReasonRadioButtons(textEditingController),
        ],
      ),
    );
  }

  Platform.isAndroid
      ? showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('$title'),
        content: getContent(),
        actions: actions,
      );
    },
  )
      : showCupertinoDialog(
    context: context,
    builder: (context) => Material(
      color: Colors.transparent,
      child: CupertinoAlertDialog(
        title: Text('$title'),
        content: getContent(),
        actions: actions,
      ),
    ),
  );
}

class ReasonRadioButtons extends StatefulWidget {
  const ReasonRadioButtons(this.textEditingController, {Key key})
      : super(key: key);

  final TextEditingController textEditingController;

  @override
  _ReasonRadioButtonsState createState() => _ReasonRadioButtonsState();
}

class _ReasonRadioButtonsState extends State<ReasonRadioButtons> {
  static String value1 = 'Got a better offer';
  static String value2 = 'Last moment changes';
  static String value3 = 'Other';

  String radioGroupValue = value1;

  void changeValue(String value) {
    setState(() {
      radioGroupValue = value;
      widget.textEditingController.text = value;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.textEditingController.text = value1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<String>(
          value: value1,
          groupValue: radioGroupValue,
          onChanged: (value) => changeValue(value),
          title: Text(value1),
        ),
        RadioListTile<String>(
          value: value2,
          groupValue: radioGroupValue,
          onChanged: (value) => changeValue(value),
          title: Text(value2),
        ),
        RadioListTile<String>(
          value: value3,
          groupValue: radioGroupValue,
          onChanged: (value) => changeValue(value),
          title: Text(value3),
        ),
        if (radioGroupValue == value3) ...[
          TextFormField(
            keyboardType: TextInputType.multiline,
            minLines: null,
            controller: widget.textEditingController,
            maxLines: 3,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ],
    );
  }
}
