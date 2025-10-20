import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static final SharedPrefs _instance = SharedPrefs._internal();
  factory SharedPrefs() => _instance;
  SharedPrefs._internal();

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  Future<void> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  Future<void> setDouble(String key, double value) async =>
      await _prefs.setDouble(key, value);

  Future<void> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);

  Future<void> setStringList(String key, List<String> value) async =>
      await _prefs.setStringList(key, value);

  String? getString(String key) => _prefs.getString(key);
  int? getInt(String key) => _prefs.getInt(key);
  double? getDouble(String key) => _prefs.getDouble(key);
  bool? getBool(String key) => _prefs.getBool(key);
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  bool containsKey(String key) => _prefs.containsKey(key);

  Future<void> remove(String key) async => await _prefs.remove(key);

  Future<void> clear() async => await _prefs.clear();

  void printAll() {
    for (var key in _prefs.getKeys()) {
      debugPrint('$key: ${_prefs.get(key)}');
    }
  }
}
