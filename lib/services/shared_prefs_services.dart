import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static final SharedPrefs _instance = SharedPrefs._internal();
  factory SharedPrefs() => _instance;
  SharedPrefs._internal();

  static late SharedPreferences _prefs;

  // ---------------- INITIALIZATION ----------------
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---------------- GENERIC SETTERS ----------------
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

  // ---------------- GENERIC GETTERS ----------------
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

  // ============================================================
  // 🔐 APP-SPECIFIC HELPERS (for Auth + Profile)
  // ============================================================

  /// ---------------- USER ROLE ----------------
  static const roleKey = "role";

  Future<void> setRole(String role) async =>
      await _prefs.setString(roleKey, role);

  String? getRole() => _prefs.getString(roleKey);

  /// ---------------- USER TOKEN ----------------
  static const userToken = "user_token";

  Future<void> setuserToken(String token) async =>
      await _prefs.setString(userToken, token);

  String? getUserToken() => _prefs.getString(userToken);

  /// ---------------- USER PROFILE COMPLETE OR NOT ----------------
  static const isProfileCompleted = "isProfileCompleted";

  Future<void> isProfileComplete(bool value) async =>
      await _prefs.setBool(isProfileCompleted, value);

  bool checkProfile() => _prefs.getBool(isProfileCompleted) ?? false;

  /// ---------------- USER ----------------
  static const user = "user";

  Future<void> setuser(String user) async =>
      await _prefs.setString(userId, user);

  String? getUser() => _prefs.getString(user);

  /// ---------------- USER ID ----------------
  static const userId = "user_id";

  Future<void> setuserId(String id) async => await _prefs.setString(userId, id);

  String? getUserId() => _prefs.getString(userId);

  /// ---------------- GLOBAL EMAIL ----------------
  static const globalEmailKey = "globalEmail";

  Future<void> setGlobalEmail(String email) async =>
      await _prefs.setString(globalEmailKey, email);

  String? getGlobalEmail() => _prefs.getString(globalEmailKey);

  // In SharedPrefs class
  Future<void> setVeriffSessionId(String sessionId) async {
    await _prefs.setString('veriff_session_id', sessionId);
  }

  Future<String?> getVeriffSessionId() async {
    return _prefs.getString('veriff_session_id');
  }

  Future<void> clearVeriffSessionId() async {
    await _prefs.remove('veriff_session_id');
  }
}
