import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    }
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    }
    if (value is int) {
      return await sharedPreferences.setInt(key, value);
    }
    if (value is double) {
      return await sharedPreferences.setDouble(key, value);
    }
    return false;
  }

  Future<bool> saveList({required String key, required List<int> value}) async {
    String encodedList = jsonEncode(value);
    return await sharedPreferences.setString(key, encodedList);
  }

  List<int> getList({required String key}) {
    String? encodedList = sharedPreferences.getString(key);
    if (encodedList != null) {
      List<dynamic> decodedList = jsonDecode(encodedList);
      return decodedList.cast<int>();
    }
    return [];
  }

  String? getDataString({required String key}) {
    return sharedPreferences.getString(key);
  }

  dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  Future<bool> containsKey({required String key}) async {
    return sharedPreferences.containsKey(key);
  }

  Future<bool> clearAllData() async {
    return await sharedPreferences.clear();
  }

  Future<bool> clearData({required String key}) async {
    return await sharedPreferences.remove(key);
  }
}
