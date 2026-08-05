import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shop_hub/data/models/index.dart" show Product;
import "package:shop_hub/domain/repositories/favorite_product_repository.dart";
import "package:shop_hub/presentation/providers/favorite_providers.dart";

class FavoriteProductState {
  const FavoriteProductState({this.favoriteProducts = const []});

  final List<Product> favoriteProducts;

  FavoriteProductState copyWith({List<Product>? favoriteProducts}) {
    return FavoriteProductState(
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
    );
  }

  @override
  String toString() {
    return "FavoriteProductState(favoriteProducts: $favoriteProducts)";
  }
}

class FavoriteProductNotifier extends AsyncNotifier<FavoriteProductState> {
  late final FavoriteProductRepository _favoriteRepository;

  @override
  Future<FavoriteProductState> build() async {
    _favoriteRepository = ref.watch(favoriteRepositoryProvider);
    return await loadItems();
  }

  Future<FavoriteProductState> loadItems() async {
    final result = await _favoriteRepository.getFavorites();
    return FavoriteProductState(favoriteProducts: result);
  }

  Future<void> addToFavorite(Product product) async {
    await _favoriteRepository.addProductToFavorites(product);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(loadItems);
  }

  Future<void> removeFromFavorite(Product product) async {
    await _favoriteRepository.removeProductFromFavorites(product);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(loadItems);
  }

  Future<void> toggleFavorite(Product product) async {
    await _favoriteRepository.toggleFavoriteProduct(product);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(loadItems);
  }

  Future<void> clearFavorites() async {
    await _favoriteRepository.clearFavorites();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(loadItems);
  }
}
