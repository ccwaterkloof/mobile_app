import 'package:shared_preferences/shared_preferences.dart';

class CcwStore {
  static const API_KEY_KEY = "key";
  static const TOKEN_KEY = "token";

  SharedPreferences prefs;

  CcwStore._(this.prefs);

  static Future<CcwStore> create() async {
    final prefs = await SharedPreferences.getInstance();
    return CcwStore._(prefs);
  }

  get apiKey {
    return prefs.getString(API_KEY_KEY);
  }

  set apiKey(String value) {
    prefs.setString(API_KEY_KEY, value);
  }

  get token {
    return prefs.getString(TOKEN_KEY);
  }

  set token(String value) {
    prefs.setString(TOKEN_KEY, value);
  }

  bool get hasKeys {
    return prefs.containsKey(TOKEN_KEY);
  }
}
