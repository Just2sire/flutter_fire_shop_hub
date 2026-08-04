import "package:connectivity_plus/connectivity_plus.dart";

class ConnectivityService {
  const ConnectivityService(this._connectivity);
  final Connectivity _connectivity;

  Future<bool> hasConnection() async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  Stream<bool> get connectionStream => _connectivity.onConnectivityChanged
      .map((results) => !results.contains(ConnectivityResult.none));
}
