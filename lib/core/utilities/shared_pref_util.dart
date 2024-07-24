import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  static final SharedPrefUtil _instance = SharedPrefUtil._internal();

  factory SharedPrefUtil() {
    return _instance;
  }

  SharedPrefUtil._internal();

  Future<void> save<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      // Convert custom objects to JSON string
      String jsonString = jsonEncode(value);
      await prefs.setString(key, jsonString);
    }
  }

  Future<T?> get<T>(String key, {T Function(Map<String, dynamic>)? fromJson}) async {
    final prefs = await SharedPreferences.getInstance();
    if (T == String) {
      return prefs.getString(key) as T?;
    } else if (T == int) {
      return prefs.getInt(key) as T?;
    } else if (T == double) {
      return prefs.getDouble(key) as T?;
    } else if (T == bool) {
      return prefs.getBool(key) as T?;
    } else if (T == List<String>) {
      return prefs.getStringList(key) as T?;
    } else {
      // Parse JSON string to custom object
      String? jsonString = prefs.getString(key);
      if (jsonString != null && fromJson != null) {
        Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return fromJson(jsonMap);
      }
      throw Exception("Unsupported type");
    }
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
