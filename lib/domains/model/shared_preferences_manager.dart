import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static Future<bool> isFirstLaunch() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(SharedPreferencesKeys.isFirstLaunch.name) ?? false;
  }

  static Future<void> writeFirstLaunch() async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool(SharedPreferencesKeys.isFirstLaunch.name, true);
  }
}

enum SharedPreferencesKeys {
  isFirstLaunch,
}