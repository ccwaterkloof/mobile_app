class TrelloCredentials {
  final String key;
  final String token;

  TrelloCredentials({required this.key, required this.token});

  Map<String, String?> get map => {"key": key, "token": token};

  bool get isEmpty => key.isEmpty || token.isEmpty;

  bool get isNotEmpty => !isEmpty;
}
