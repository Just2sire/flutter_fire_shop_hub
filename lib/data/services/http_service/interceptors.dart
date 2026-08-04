import "dart:async";
import "dart:convert";

import "package:http/http.dart" as http;

import "../../../../core/configs/logger.dart";

class RequestData {
  RequestData({
    required this.method,
    required this.uri,
    Map<String, String>? headers,
    this.body,
    this.encoding,
    this.timeout,
    this.queryParameters,
    this.requiresAuth = true,
  }) : headers = headers ?? {};

  String method;
  Uri uri;
  Map<String, String> headers;
  Object? body;
  Encoding? encoding;
  Duration? timeout;
  Map<String, String>? queryParameters;
  bool requiresAuth;

  bool hasAuthorizationHeader() {
    final key = headers.keys.firstWhere(
      (k) => k.toLowerCase() == "authorization",
      orElse: () => "",
    );
    return key.isNotEmpty;
  }
}

class ResponseContext {
  ResponseContext({required this.request, this.response, this.error});

  final RequestData request;
  http.Response? response;
  Object? error;
}

mixin RequestInterceptor {
  FutureOr<RequestData> onRequest(RequestData request);
}

mixin ResponseInterceptor {
  FutureOr<ResponseContext> onResponse(ResponseContext context);
}

class AuthInterceptor implements RequestInterceptor {
  AuthInterceptor([this._getToken]);
  final Future<String?> Function()? _getToken;

  @override
  FutureOr<RequestData> onRequest(RequestData request) async {
    if (!request.requiresAuth || request.hasAuthorizationHeader()) {
      return request;
    }
    final token = _getToken != null ? await _getToken() : null;
    if (token != null && token.isNotEmpty) {
      request.headers["Authorization"] = "Bearer $token";
    }
    return request;
  }
}

class LoggingInterceptor implements RequestInterceptor, ResponseInterceptor {
  @override
  FutureOr<RequestData> onRequest(RequestData request) {
    Log.d("[REQ] ${request.method} ${request.uri}", tag: "API");
    return request;
  }

  @override
  FutureOr<ResponseContext> onResponse(ResponseContext context) {
    if (context.response != null) {
      Log.d(
        "[RES] ${context.request.method} ${context.request.uri} "
        "→ ${context.response!.statusCode}",
        tag: "API",
      );
    } else if (context.error != null) {
      Log.e(
        "[ERR] ${context.request.method} ${context.request.uri} "
        "→ ${context.error}",
        tag: "API",
      );
    }
    return context;
  }
}
