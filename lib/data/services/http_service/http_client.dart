import "dart:convert";

import "package:http/http.dart" as http;

abstract class IHttpClient {
  Future<http.Response> get(
    Uri uri, {
    Map<String, String>? headers,
    Duration? timeout,
  });

  Future<http.Response> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration? timeout,
  });

  Future<http.Response> put(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration? timeout,
  });

  Future<http.Response> patch(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration? timeout,
  });

  Future<http.Response> delete(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration? timeout,
  });

  Future<http.StreamedResponse> sendMultipart(
    Uri uri, {
    required List<http.MultipartFile> files,
    Map<String, String>? headers,
    Map<String, String>? fields,
    Duration? timeout,
  });
}

class HttpClientImpl implements IHttpClient {
  HttpClientImpl({http.Client? inner, this.defaultHeaders = const {}})
      : _inner = inner ?? http.Client();

  final http.Client _inner;
  final Map<String, String> defaultHeaders;

  Map<String, String> _merge(Map<String, String>? headers) =>
      {...defaultHeaders, ...?headers};

  @override
  Future<http.Response> get(
    Uri uri, {
    Map<String, String>? headers,
    Duration? timeout,
  }) {
    final req = _inner.get(uri, headers: _merge(headers));
    return timeout != null ? req.timeout(timeout) : req;
  }

  @override
  Future<http.Response> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration? timeout,
  }) {
    final req = _inner.post(
      uri,
      headers: _merge(headers),
      body: body,
      encoding: encoding,
    );
    return timeout != null ? req.timeout(timeout) : req;
  }

  @override
  Future<http.Response> put(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration? timeout,
  }) {
    final req = _inner.put(
      uri,
      headers: _merge(headers),
      body: body,
      encoding: encoding,
    );
    return timeout != null ? req.timeout(timeout) : req;
  }

  @override
  Future<http.Response> patch(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration? timeout,
  }) {
    final req = _inner.patch(
      uri,
      headers: _merge(headers),
      body: body,
      encoding: encoding,
    );
    return timeout != null ? req.timeout(timeout) : req;
  }

  @override
  Future<http.Response> delete(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration? timeout,
  }) {
    final req = _inner.delete(
      uri,
      headers: _merge(headers),
      body: body,
      encoding: encoding,
    );
    return timeout != null ? req.timeout(timeout) : req;
  }

  @override
  Future<http.StreamedResponse> sendMultipart(
    Uri uri, {
    required List<http.MultipartFile> files,
    Map<String, String>? headers,
    Map<String, String>? fields,
    Duration? timeout,
  }) async {
    final request = http.MultipartRequest("POST", uri);
    if (headers != null) request.headers.addAll(headers);
    if (fields != null) request.fields.addAll(fields);
    for (final f in files) {
      request.files.add(f);
    }
    final future = _inner.send(request);
    return timeout != null ? future.timeout(timeout) : future;
  }
}
