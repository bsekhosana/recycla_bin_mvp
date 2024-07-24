import 'dart:convert';
import 'package:recycla_bin/core/constants/shared_preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rb_collection.dart';

class SharedPrefProvider {

  Future<void> saveRBCollection(RBCollection collection) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(collection.toJson());
    await prefs.setString(AppSharedKeys.cachedRBCollection, jsonString);
  }

  Future<RBCollection?> getRBCollection() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(AppSharedKeys.cachedRBCollection);
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return RBCollection.fromJson(jsonMap);
    }
    return null;
  }

  Future<void> removeRBCollection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppSharedKeys.cachedRBCollection);
  }
}
