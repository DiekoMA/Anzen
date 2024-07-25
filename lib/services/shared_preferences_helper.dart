import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance =
      SharedPreferencesHelper._internal();
  SharedPreferences? _prefs;

  factory SharedPreferencesHelper() {
    return _instance;
  }

  SharedPreferencesHelper._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Ensure _prefs is initialized before accessing it
  void _checkInitialization() {
    if (_prefs == null) {
      throw Exception(
          "SharedPreferencesHelper is not initialized. Call init() first.");
    }
  }

  // Set methods
  Future<void> setString(String key, String value) async {
    _checkInitialization();
    await _prefs!.setString(key, value);
  }

  Future<void> setInt(String key, int value) async {
    _checkInitialization();
    await _prefs!.setInt(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    _checkInitialization();
    await _prefs!.setBool(key, value);
  }

  Future<void> setDouble(String key, double value) async {
    _checkInitialization();
    await _prefs!.setDouble(key, value);
  }

  Future<void> setStringList(String key, List<String> value) async {
    _checkInitialization();
    await _prefs!.setStringList(key, value);
  }

  // Get methods
  String? getString(String key) {
    _checkInitialization();
    return _prefs!.getString(key);
  }

  int? getInt(String key) {
    _checkInitialization();
    return _prefs!.getInt(key);
  }

  bool? getBool(String key) {
    _checkInitialization();
    return _prefs!.getBool(key);
  }

  double? getDouble(String key) {
    _checkInitialization();
    return _prefs!.getDouble(key);
  }

  List<String>? getStringList(String key) {
    _checkInitialization();
    return _prefs!.getStringList(key);
  }

  // Remove method
  Future<void> remove(String key) async {
    _checkInitialization();
    await _prefs!.remove(key);
  }

  // Clear all preferences
  Future<void> clear() async {
    _checkInitialization();
    await _prefs!.clear();
  }
}
