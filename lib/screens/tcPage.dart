import 'package:flutter/material.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import 'package:trukapp/utils/constants.dart';

class TCPage extends StatelessWidget {
  Locale locale;
  String data ;

  TCPage({this.data});

  @override
  Widget build(BuildContext context) {
    print(data);
    locale = AppLocalizations.of(context).locale;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "${AppLocalizations.getLocalizationValue(this.locale, LocaleKey.insuranceText2)}",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: RichText(
              text: TextSpan(
                text: data == null?
                    "${AppLocalizations.getLocalizationValue(this.locale, LocaleKey.TC)}" : data,
                style: TextStyle(color: Colors.black),
              ),
            )),
          ),
        ),
      ),
    );
  }
}
