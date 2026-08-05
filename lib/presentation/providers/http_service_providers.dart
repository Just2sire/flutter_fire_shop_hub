import "package:connectivity_plus/connectivity_plus.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:http/http.dart" as http;
import "package:shop_hub/data/services/http_service/index.dart";

final connectivityServiceProvider = Provider(
  (ref) => ConnectivityService(Connectivity()),
);

final networkStatusProvider = StreamProvider<bool>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  return connectivityService.connectionStream;
});

final apiServiceProvider = Provider((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);

  final httpClient = HttpClientImpl(
    inner: http.Client(),
    defaultHeaders: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Accept-Language": "fr",
      "X-App-Version": "1.0.0",
    },
  );

  return ApiService(
    httpClient: httpClient,
    baseUrl: "https://dummyjson.com",
    checkConnectivity: connectivity.hasConnection,
    requestInterceptors: [LoggingInterceptor()],
    responseInterceptors: [LoggingInterceptor()],
  );
});
