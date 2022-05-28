import 'dart:convert';
import 'package:ccw/models/credentials.dart';
import 'package:ccw/models/errors.dart';
import 'package:http/http.dart' as http;

class LoginService {
  Future<TrelloCredentials> login(String password) async {
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
    final token = raw["token"] ?? "";
    final key = raw["key"] ?? "";
    if (token.isEmpty || key.isEmpty) {
      throw "Authentication service error.";
    }

    return TrelloCredentials(key: key, token: token);
  }
}
