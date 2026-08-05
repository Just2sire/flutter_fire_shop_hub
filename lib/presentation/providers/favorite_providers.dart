import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shop_hub/data/repositories/favorite_product_repository_impl.dart";
import "package:shop_hub/presentation/providers/state_providers/favorite_product_state.dart";
import "package:shop_hub/presentation/providers/storage_providers.dart";

final favoriteRepositoryProvider = Provider((ref) {
  return FavoriteProductRepositoryImpl(ref.watch(localStorageServiceProvider));
});

final favoriteProductProvider =
    AsyncNotifierProvider<FavoriteProductNotifier, FavoriteProductState>(
      FavoriteProductNotifier.new,
    );
