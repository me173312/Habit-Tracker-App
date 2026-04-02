import 'package:shared_preferences/shared_preferences.dart';

class CashNetwork {
  static late SharedPreferences shardPref;
  static Future cashInitialization() async {
    shardPref = await SharedPreferences.getInstance();
  }
  // set - get -delete - clear

  static Future<bool> InsertToCash(
      {required String key, required bool value}) async {
    return await shardPref.setBool(key, value);
  }

  static bool GetFromCash({required String key}) {
    return shardPref.getBool(key) ?? true;
  }

  static Future<bool> DeletFromCach({required String key}) async {
    return await shardPref.remove(key);
  }

  static Future<bool> clearData() async {
    return await shardPref.clear();
  }
}
