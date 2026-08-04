import "dart:async";
import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;

import "index.dart";

class ApiService {
  ApiService({
    required IHttpClient httpClient,
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    this.defaultHeaders = const {
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    this.getToken,
    this.onUnauthorized,
    this.checkConnectivity,
    this.requestInterceptors = const [],
    this.responseInterceptors = const [],
  }) : _client = httpClient;

  final IHttpClient _client;
  final String baseUrl;
  final Duration timeout;
  final Map<String, String> defaultHeaders;
  final Future<String?> Function()? getToken;
  final Future<bool> Function()? onUnauthorized;
  final Future<bool> Function()? checkConnectivity;
  final List<RequestInterceptor> requestInterceptors;
  final List<ResponseInterceptor> responseInterceptors;

  // ── Public methods ────────────────────────────────────────────────────────

  Future<Either<Failure, T>> get<T>(
    String path, {
    Map<String, String>? headers,
    bool requireAuth = false,
    Map<String, String>? queryParameters,
    T Function(Map<String, dynamic>)? parser,
  }) => _request<T>(
        method: "GET",
        path: path,
        headers: headers,
        queryParameters: queryParameters,
        requireAuth: requireAuth,
        parser: parser,
      );

  Future<Either<Failure, T>> post<T>(
    String path, {
    Map<String, String>? headers,
    Object? body,
    bool requireAuth = false,
    T Function(Map<String, dynamic>)? parser,
  }) => _request<T>(
        method: "POST",
        path: path,
        headers: headers,
        body: body,
        requireAuth: requireAuth,
        parser: parser,
      );

  Future<Either<Failure, T>> put<T>(
    String path, {
    Map<String, String>? headers,
    Object? body,
    bool requireAuth = false,
    T Function(Map<String, dynamic>)? parser,
  }) => _request<T>(
        method: "PUT",
        path: path,
        headers: headers,
        body: body,
        requireAuth: requireAuth,
        parser: parser,
      );

  Future<Either<Failure, T>> patch<T>(
    String path, {
    Map<String, String>? headers,
    Object? body,
    bool requireAuth = false,
    T Function(Map<String, dynamic>)? parser,
  }) => _request<T>(
        method: "PATCH",
        path: path,
        headers: headers,
        body: body,
        requireAuth: requireAuth,
        parser: parser,
      );

  Future<Either<Failure, T>> delete<T>(
    String path, {
    Map<String, String>? headers,
    Object? body,
    bool requireAuth = false,
    T Function(Map<String, dynamic>)? parser,
  }) => _request<T>(
        method: "DELETE",
        path: path,
        headers: headers,
        body: body,
        requireAuth: requireAuth,
        parser: parser,
      );

  Future<Either<Failure, T>> uploadMultipart<T>(
    String path, {
    required List<http.MultipartFile> files,
    Map<String, String>? headers,
    Map<String, String>? fields,
    bool requireAuth = false,
    T Function(Map<String, dynamic>)? parser,
  }) async {
    final uri = _buildUri(path);
    final merged = _mergeHeaders(headers);
    final initialReq = RequestData(
      method: "POST",
      uri: uri,
      headers: merged,
      timeout: timeout,
      requiresAuth: requireAuth,
    );

    final req = await _runRequestInterceptors(initialReq);

    try {
      final streamed = await _client.sendMultipart(
        req.uri,
        headers: req.headers,
        files: files,
        fields: fields,
        timeout: req.timeout,
      );
      var resp = await http.Response.fromStream(streamed);
      final ctx = ResponseContext(request: req, response: resp);
      final finalCtx = await _runResponseInterceptors(ctx);
      resp = finalCtx.response ?? resp;
      return _parseResponse<T>(resp, parser);
    } catch (e) {
      return left(Failure(
        message: "Erreur upload: $e",
        type: FailureType.unknown,
      ));
    }
  }

  // ── Internal ──────────────────────────────────────────────────────────────

  Uri _buildUri(String path, [Map<String, String>? queryParameters]) {
    final uri = Uri.parse(path.startsWith("http") ? path : baseUrl + path);
    if (queryParameters == null || queryParameters.isEmpty) return uri;
    return uri.replace(
      queryParameters: {...uri.queryParameters, ...queryParameters},
    );
  }

  Map<String, String> _mergeHeaders(Map<String, String>? headers) =>
      {...defaultHeaders, ...?headers};

  Future<RequestData> _runRequestInterceptors(RequestData req) async {
    var current = req;
    for (final interceptor in requestInterceptors) {
      final result = interceptor.onRequest(current);
      current = result is Future<RequestData> ? await result : result;
    }
    if (current.requiresAuth &&
        !current.hasAuthorizationHeader() &&
        getToken != null) {
      final token = await getToken!();
      if (token != null && token.isNotEmpty) {
        current.headers["Authorization"] = "Bearer $token";
      }
    }
    return current;
  }

  Future<ResponseContext> _runResponseInterceptors(ResponseContext ctx) async {
    var current = ctx;
    for (final interceptor in responseInterceptors) {
      final result = interceptor.onResponse(current);
      current = result is Future<ResponseContext> ? await result : result;
    }
    return current;
  }

  Future<Either<Failure, http.Response>> _executeRequest(
    Future<http.Response> Function() request,
    RequestData req,
  ) async {
    if (checkConnectivity != null) {
      final connected = await checkConnectivity!();
      if (!connected) {
        const failure = Failure(
          message: "Pas de connexion internet",
          type: FailureType.noInternet,
        );
        await _runResponseInterceptors(
          ResponseContext(request: req, error: failure),
        );
        return left(failure);
      }
    }

    try {
      final response = await request().timeout(
        timeout,
        onTimeout: () => throw TimeoutException(
          "Timeout après ${timeout.inSeconds}s",
        ),
      );
      await _runResponseInterceptors(
        ResponseContext(request: req, response: response),
      );
      return right(response);
    } on TimeoutException {
      final failure = Failure(
        message: "La requête a expiré après ${timeout.inSeconds} secondes",
        type: FailureType.timeout,
      );
      await _runResponseInterceptors(
        ResponseContext(request: req, error: failure),
      );
      return left(failure);
    } on SocketException catch (e) {
      final failure = Failure(
        message: "Erreur réseau: ${e.message}",
        type: FailureType.noInternet,
      );
      await _runResponseInterceptors(
        ResponseContext(request: req, error: failure),
      );
      return left(failure);
    } on FormatException catch (e) {
      final failure = Failure(
        message: "Format invalide: ${e.message}",
        type: FailureType.invalidResponse,
      );
      await _runResponseInterceptors(
        ResponseContext(request: req, error: failure),
      );
      return left(failure);
    } catch (e) {
      final failure = Failure(
        message: "Erreur inattendue: $e",
        type: FailureType.noInternet,
      );
      await _runResponseInterceptors(
        ResponseContext(request: req, error: e),
      );
      return left(failure);
    }
  }

  Either<Failure, T> _parseResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? parser,
  ) {
    final status = response.statusCode;

    if (response.body.isEmpty) {
      return status >= 200 && status < 300
          ? right(null as T)
          : left(Failure(
              message: response.reasonPhrase ?? "Erreur inconnue",
              statusCode: status,
              type: _failureType(status),
            ));
    }

    try {
      final decoded = json.decode(response.body);

      if (status >= 200 && status < 300) {
        if (parser != null && decoded is Map<String, dynamic>) {
          return right(parser(decoded));
        }
        return right(decoded as T);
      }

      String? message;
      if (decoded is Map) {
        message =
            decoded["message"]?.toString() ?? decoded["error"]?.toString();
      }
      return left(Failure(
        message: message ?? response.reasonPhrase ?? "Erreur inconnue",
        statusCode: status,
        type: _failureType(status),
        data: decoded,
      ));
    } catch (e) {
      return left(Failure(
        message: "Erreur de décodage: $e",
        statusCode: status,
        type: FailureType.invalidResponse,
      ));
    }
  }

  FailureType _failureType(int statusCode) => switch (statusCode) {
        401 => FailureType.unauthorized,
        403 => FailureType.forbidden,
        404 => FailureType.notFound,
        422 => FailureType.validationError,
        >= 400 && < 500 => FailureType.clientError,
        >= 500 => FailureType.serverError,
        _ => FailureType.unknown,
      };

  Future<Either<Failure, T>> _request<T>({
    required String method,
    required String path,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
    Object? body,
    bool requireAuth = false,
    T Function(Map<String, dynamic>)? parser,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final merged = _mergeHeaders(headers);
    final initialReq = RequestData(
      method: method,
      uri: uri,
      headers: merged,
      body: body,
      timeout: timeout,
      queryParameters: queryParameters,
      requiresAuth: requireAuth,
    );

    final req = await _runRequestInterceptors(initialReq);

    Future<http.Response> Function() closure;

    switch (req.method.toUpperCase()) {
      case "GET":
        closure = () => _client.get(req.uri, headers: req.headers);
      case "POST":
        final encoded =
            req.body is Map ? json.encode(req.body) : req.body;
        closure = () => _client.post(
              req.uri,
              headers: req.headers,
              body: encoded,
              encoding: req.encoding,
            );
      case "PUT":
        final encoded =
            req.body is Map ? json.encode(req.body) : req.body;
        closure = () => _client.put(
              req.uri,
              headers: req.headers,
              body: encoded,
              encoding: req.encoding,
            );
      case "PATCH":
        final encoded =
            req.body is Map ? json.encode(req.body) : req.body;
        closure = () => _client.patch(
              req.uri,
              headers: req.headers,
              body: encoded,
              encoding: req.encoding,
            );
      case "DELETE":
        final encoded =
            req.body is Map ? json.encode(req.body) : req.body;
        closure = () => _client.delete(
              req.uri,
              headers: req.headers,
              body: encoded,
              encoding: req.encoding,
            );
      default:
        return left(Failure(
          message: "Méthode HTTP non supportée: ${req.method}",
          type: FailureType.unknown,
        ));
    }

    final responseResult = await _executeRequest(closure, req);

    final result = responseResult.fold(
      (f) => left<Failure, T>(f),
      (response) => _parseResponse<T>(response, parser),
    );

    await result.fold(
      (failure) async {
        if (failure.type == FailureType.unauthorized &&
            onUnauthorized != null) {
          await onUnauthorized!();
        }
      },
      (_) async {},
    );

    return result;
  }
}
