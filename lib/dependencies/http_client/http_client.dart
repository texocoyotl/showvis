import 'dart:convert';

import 'package:http_client/console.dart';

abstract class HttpClient {
  void dispose();
  Future<Map<String, dynamic>> query(
      {String method = 'GET', required String path, required Function onError});
}

class HttpClientProd implements HttpClient {
  HttpClientProd({required this.baseUrl, ConsoleClient? client})
      : _client = client ?? ConsoleClient();

  final ConsoleClient _client;
  final String baseUrl;

  @override
  void dispose() {
    _client.close(force: true);
  }

  @override
  Future<Map<String, dynamic>> query({
    String method = 'GET',
    required String path,
    required Function onError,
  }) async {
    final rs = await _client.send(Request(method, '$baseUrl$path'));
    final textContent = await rs.readAsString();
    final content = json.decode(textContent);
    return {'data': content};
  }
}
