import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static save(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(key, value);
  }

  static get(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key);
  }

  static remove(key) async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove(key);
  }

  Storage();
}
