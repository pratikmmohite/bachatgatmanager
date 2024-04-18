/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

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

  static Future<bool> saveLocal([String value = "mr"]) async {
    var pref = await prefs;
    return await pref.setString(AppConstants.sfLanguage, value);
  }

  static Future<String> getLocal([String defaultValue = "en"]) async {
    var pref = await prefs;
    return pref.getString(AppConstants.sfLanguage) ?? defaultValue;
  }

  static Future<bool> saveViewMode([String value = "mr"]) async {
    var pref = await prefs;
    return await pref.setString(AppConstants.sfViewMode, value);
  }

  static Future<String> getViewMode([String defaultValue = "en"]) async {
    var pref = await prefs;
    return pref.getString(AppConstants.sfViewMode) ?? defaultValue;
  }
}
