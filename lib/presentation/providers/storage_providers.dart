import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:shop_hub/data/services/local_storage_service.dart";

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    "sharedPreferencesProvider doit être override dans ProviderScope",
  ),
);

final localStorageServiceProvider = Provider<LocalStorageService>(
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    return LocalStorageService(prefs);
  },
);
