import 'dart:convert';

import 'package:http_client/console.dart';

abstract class HttpClient {
  void dispose();
  Future<JsonResponse> query({String method = 'GET', required String path});
}

class HttpClientImpl implements HttpClient {
  HttpClientImpl({required this.baseUrl, ConsoleClient? client})
      : _client =
            client ?? ConsoleClient(idleTimeout: const Duration(seconds: 5));

  final ConsoleClient _client;
  final String baseUrl;

  @override
  void dispose() {
    _client.close(force: true);
  }

  @override
  Future<JsonResponse> query({
    String method = 'GET',
    required String path,
  }) async {
    try {
      final rs = await _client.send(Request(method, '$baseUrl$path'));
      if (rs.statusCode < 200 || rs.statusCode >= 300) {
        return JsonFailureResponse.fromStatusCode(rs.statusCode);
      }
      final textContent = await rs.readAsString();
      final content = json.decode(textContent);

      return JsonSuccessResponse(content);
    } catch (e) {
      return JsonFailureResponse(reason: FailureReason.connectivity);
    }
  }
}

abstract class JsonResponse {}

class JsonSuccessResponse extends JsonResponse {
  JsonSuccessResponse(this.content);

  final dynamic content;
}

class JsonFailureResponse extends JsonResponse {
  JsonFailureResponse({this.reason = FailureReason.unknown});
  final FailureReason reason;

  JsonFailureResponse.fromStatusCode(int code) : reason = _mapReason(code);

  static FailureReason _mapReason(int code) {
    if (code == 400) return FailureReason.server;
    if (code == 404) return FailureReason.invalidUri;
    if (code == 500) return FailureReason.internal;
    return FailureReason.unknown;
  }
}

enum FailureReason { unknown, connectivity, server, invalidUri, internal }
