import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models.dart';

// using a global singleton for now
// if this grows we might need to manage the instance via Provider
final Cloud cloud = new Cloud();

class Cloud {
  String _apiKey;
  String _token;

  final apiAuthority = "trello.com";
  final boardId = "RnN9JX0z";
  final currentColumnId = "5e0dafbf4c13d83b0d74204c";

  setAuth(String apiKey, String token) {
    _apiKey = apiKey;
    _token = token;
  }

  Future<List<Member>> fetchMembers() async {
    final params = {
      "fields": "name,desc,due",
      "attachments": "true",
      "attachment_fields": "url",
      ..._credentials
    };

    final uri = Uri.https(
      apiAuthority,
      '/1/lists/$currentColumnId/cards',
      params,
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      print('Error code: ${response.statusCode}');
      throw Error();
    }

    var raw = json.decode(response.body);
    return Member.formList(raw);
  }

  Map<String, String> get _credentials {
    return {"key": _apiKey, "token": _token};
  }

  Future<List<String>> login(String password) async {
    final params = {
      "password": password,
    };

    final uri = Uri.https(
      'ccw.kiekies.net',
      '',
      params,
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      print('Error code: ${response.statusCode}');
      throw Error();
    }

    var raw = json.decode(response.body);
    setAuth(raw['key'], raw['token']);

    return [
      raw['key'],
      raw['token'],
    ];
  }
}
