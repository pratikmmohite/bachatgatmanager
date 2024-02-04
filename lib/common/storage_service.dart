import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static Future<bool> write(String key, String value) async {
    var pref = await prefs;
    return await pref.setString(key, value);
  }

  static Future<String> read(String key, [String defaultValue = ""]) async {
    var pref = await prefs;
    return pref.getString(key) ?? defaultValue;
  }
}
