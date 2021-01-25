import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import '../utils/constants.dart';

void paymentSuccessful({String shipmentId, BuildContext context, bool isPayment = true, Function onTap}) {
  final locale = AppLocalizations.of(context).locale;
  Platform.isAndroid
      ? showDialog(
          context: context,
          barrierDismissible: true,
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
                          ? AppLocalizations.getLocalizationValue(locale, LocaleKey.paymentSuccess)
                          : AppLocalizations.getLocalizationValue(locale, LocaleKey.bookingRequested),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      AppLocalizations.getLocalizationValue(locale, LocaleKey.done),
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
                            ? AppLocalizations.getLocalizationValue(locale, LocaleKey.paymentSuccess)
                            : AppLocalizations.getLocalizationValue(locale, LocaleKey.bookingRequested),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        AppLocalizations.getLocalizationValue(locale, LocaleKey.done),
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

void showConfirmationDialog({BuildContext context, String title, String subTitle, Function onTap}) {
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
                    AppLocalizations.getLocalizationValue(locale, LocaleKey.yes),
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
                      AppLocalizations.getLocalizationValue(locale, LocaleKey.yes),
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Center(
                    child: Text(
                      AppLocalizations.getLocalizationValue(locale, LocaleKey.no),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
}
