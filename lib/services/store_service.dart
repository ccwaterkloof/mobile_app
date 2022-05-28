import 'package:ccw/models/credentials.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreService {
  static StoreService? _instance;
  final SharedPreferences _prefs;

  StoreService._(this._prefs);

  static Future<StoreService> create() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();

      _instance = StoreService._(prefs);
    }

    return _instance!;
  }

  bool get hasKeys => credentials.isNotEmpty;

  TrelloCredentials get credentials => TrelloCredentials(
        key: _prefs.getString(_Keys.key.name) ?? "",
        token: _prefs.getString(_Keys.token.name) ?? "",
      );

  Future<void> setCredentials(TrelloCredentials value) async {
    _prefs.setString(_Keys.key.name, value.key);
    _prefs.setString(_Keys.token.name, value.token);
  }

  Future logout() async {
    await _prefs.remove(_Keys.key.name);
    await _prefs.remove(_Keys.token.name);
  }

  bool get hasFoundDates => _prefs.getBool(_Keys.hasFoundDates.name) ?? false;

  Future<void> setHasFoundDates(bool value) async {
    _prefs.setBool(_Keys.hasFoundDates.name, value);
  }
}

enum _Keys {
  key,
  token,
  hasFoundDates,
}
