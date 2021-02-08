import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models.dart';

class MemberService extends ChangeNotifier {
  final _apiAuthority = "trello.com";
  final _currentColumnId = "5e0dafbf4c13d83b0d74204c";

  final SharedPreferences _prefs;
  Timer _readyTimer;
  String _apiKey;
  String _apiToken;

  MemberService._(this._prefs) {
    _apiKey = _prefs.getString("key");
    _apiToken = _prefs.getString("token");
    nameIsReady = false;

    if (!hasKeys) return;

    fetchMembers();

    // .then((_) {
    //   // the delay should be about as long as it takes
    //   // to download the member image
    //   _readyTimer = Timer(Duration(seconds: 1), () {
    //     nameIsReady = true;
    //     notifyListeners();
    //   });
    // });
  }

  static Future<MemberService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return MemberService._(prefs);
  }

  // ------------------------------------
  // Searching
  // ------------------------------------

  Map<String, List<String>> _searchIndex;
  List<String> get searchKeys {
    final keys = _searchIndex.keys.toList();
    keys.add("");
    keys.sort();
    return keys;
  }

  String _searchFilter;
  String get searchFilter => _searchFilter;
  set searchFilter(String value) {
    _searchFilter = value;
    notifyListeners();
  }

  List<Member> get _filteredList {
    if (_searchFilter?.isEmpty ?? true) return _list;

    final shortList = _searchIndex[_searchFilter];
    return _list.where((member) => shortList.contains(member.id)).toList();
  }

  // ------------------------------------
  // Events bus
  // ------------------------------------

  final StreamController<String> _feedbackStream =
      StreamController<String>.broadcast();
  Stream<String> get feedbackStream => _feedbackStream.stream;

  // ------------------------------------
  // Trello
  // ------------------------------------

  List<Member> _list;
  List<Member> get list => _filteredList;

  bool nameIsReady;

  Future<void> fetchMembers({bool isInitial = true}) async {
    final params = {
      "fields": "name,desc",
      "attachments": "cover",
      "attachment_fields": "url",
      "checklists": "all",
      "checklist_fields": "name,checkItems",
      ..._credentials
    };

    final uri = Uri.https(
      _apiAuthority,
      '/1/lists/$_currentColumnId/cards',
      params,
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      _feedbackStream.sink
          .add("Yikes! Technical difficulty: ${response.statusCode}");
      return;
    }

    final raw = json.decode(response.body);
    _list = Member.formList(raw);

    // build the search index
    _searchIndex = {};

    for (final member in _list) {
      for (final c in member.capitals) {
        _searchIndex.update(c, (ids) {
          if (ids.contains(member.id)) return ids;
          ids.add(member.id);
          return ids;
        }, ifAbsent: () => [member.id]);
      }
    }

    // animation trigger
    if (!isInitial) return;

    Future.delayed(Duration(seconds: 1), () {
      nameIsReady = true;
      notifyListeners();
    });

    notifyListeners();
  }

  // ------------------------------------
  // Authentication
  // ------------------------------------

  Future logout() async {
    await _prefs?.remove("token");
    _apiToken = null;
    await _prefs?.remove("key");
    _apiKey = null;
    notifyListeners();
  }

  bool get hasKeys {
    return _prefs.containsKey("token");
  }

  Future<void> login(String password) async {
    final params = {
      "password": password,
    };

    final uri = Uri.https(
      'ccw.kiekies.net',
      '',
      params,
    );
    final response = await http.get(uri);

    if (response.statusCode == 401) {
      throw FourOhOneError();
    }

    if (response.statusCode != 200) {
      throw "Login error code ${response.statusCode}";
    }

    final raw = json.decode(response.body);
    await _setApiKey(raw['key']);
    await _setToken(raw['token']);
    notifyListeners();

    fetchMembers();
  }

  Map<String, String> get _credentials {
    return {"key": _apiKey, "token": _apiToken};
  }

  Future<void> _setApiKey(String value) async {
    _apiKey = value;
    _prefs.setString("key", _apiKey);
  }

  Future<void> _setToken(String value) async {
    _apiToken = value;
    _prefs.setString("token", _apiToken);
  }

  @override
  void dispose() {
    _readyTimer?.cancel();
    _feedbackStream.close();
    super.dispose();
  }
}

class FourOhOneError {}
