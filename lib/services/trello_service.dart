import 'dart:convert';
import 'package:ccw/models/member.dart';
import 'package:ccw/models/errors.dart';
import 'package:ccw/services/store_service.dart';
import 'package:http/http.dart' as http;

class TrelloService {
  final StoreService _store;
  final _apiAuthority = "trello.com";
  final _memberColumnId = "5e0dafbf4c13d83b0d74204c";

  TrelloService(this._store);

  Future<List<Member>> fetchMembers({bool isInitial = true}) async {
    final credentials = _store.credentials;
    if (credentials.isEmpty) return [];

    final params = {
      "fields": "name,desc",
      "checklists": "all",
      "checklist_fields": "name,checkItems",
      ...credentials.map
    };

    final uri = Uri.https(
      _apiAuthority,
      '/1/lists/$_memberColumnId/cards',
      params,
    );

    http.Response response;

    try {
      response = await http.get(uri);
    } catch (e) {
      // give the home screen a chance to hook to the event listener
      await Future.delayed(const Duration(seconds: 2));
      throw FeedbackException("No connection to fetch the data.");
    }

    if (response.statusCode != 200) {
      throw FeedbackException(
          "Yikes! Technical difficulty: ${response.statusCode}");
    }

    final raw = json.decode(response.body);
    return Member.formList(raw);
  }
}
