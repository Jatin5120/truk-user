import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPreferences pref;

  static const THEME_STATUS = "THEMESTATUS";
  //login
  static const String KEY_EMAIL = "email";
  static const String KEY_NAME = "name";
  static const String KEY_MOBILE = "mobile";
  static const String KEY_THEME = "theme";
  static const String KEY_ISLOGIN = "islogin";
  static const String KEY_UID = "uid";

  Future<bool> isOld() async {
    pref = await SharedPreferences.getInstance();
    return pref.getBool("isold") ?? false;
  }

  Future<bool> setOld() async {
    pref = await SharedPreferences.getInstance();
    return pref.setBool("isold", true) ?? false;
  }

  setDarkTheme(bool value) async {
    pref = await SharedPreferences.getInstance();
    pref.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    pref = await SharedPreferences.getInstance();
    return pref.getBool(THEME_STATUS) ?? false;
  }

  createSession(uid, name, email, mobile) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(SharedPref.KEY_UID, uid);
    pref.setString(SharedPref.KEY_NAME, name);
    pref.setString(SharedPref.KEY_EMAIL, email);
    pref.setString(SharedPref.KEY_MOBILE, mobile);
    pref.setBool(SharedPref.KEY_ISLOGIN, true);
  }

  logoutUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(SharedPref.KEY_ISLOGIN, false);
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.get(SharedPref.KEY_ISLOGIN) ?? false;
  }
}
