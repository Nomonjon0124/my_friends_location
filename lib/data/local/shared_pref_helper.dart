import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper{
  SharedPrefHelper._();

  static late SharedPreferences pref;

  static Future<void> init() async {
    pref = await SharedPreferences.getInstance();
  }

  static const String _key = 'is_logged_in';

  static void setLoggedIn(bool value) {
    final SharedPreferences prefs = pref;
    prefs.setBool(_key, value);
  }

  static bool isLoggedIn() {
    final SharedPreferences prefs = pref;
    return prefs.getBool(_key) ?? false;
  }

}