import 'package:flutter/cupertino.dart';
import 'package:trukapp/sessionmanagement/session_manager.dart';

class LocalizationController with ChangeNotifier {
  Locale myLocale = Locale('en', 'US');
  Locale get locale => myLocale;

  getLocale() {
    SharedPref().getLocale().then((locale) {
      myLocale = locale;
      notifyListeners();
    });
  }

  setLocale(String langCode) {
    SharedPref().setLocale(langCode).then((value) {
      notifyListeners();
    });
  }
}
