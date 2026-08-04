import "dart:io";

/// Create HttpClient with SSL certificate bypass
/// ONLY FOR DEVELOPMENT - REMOVE IN PRODUCTION
HttpClient createInsecureHttpClient() {
  final client = HttpClient()
  // Ignore SSL certificate validation - DEVELOPMENT ONLY
  ..badCertificateCallback =
      (cert, host, port) => true;
  return client;
}
