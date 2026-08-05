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
    final currentFavorites = state.value?.favoriteProducts ?? [];
    final updatedList = [...currentFavorites, product];
    state = AsyncValue.data(
      FavoriteProductState(favoriteProducts: updatedList),
    );
    try {
      await _favoriteRepository.addProductToFavorites(product);
    } catch (e) {
      state = AsyncValue.data(
        FavoriteProductState(favoriteProducts: currentFavorites),
      );
    }
  }

  Future<void> removeFromFavorite(Product product) async {
    final currentFavorites = state.value?.favoriteProducts ?? [];
    final updatedList = currentFavorites
        .where((p) => p.id != product.id)
        .toList();
    state = AsyncValue.data(
      FavoriteProductState(favoriteProducts: updatedList),
    );
    try {
      await _favoriteRepository.removeProductFromFavorites(product);
    } catch (e) {
      state = AsyncValue.data(
        FavoriteProductState(favoriteProducts: currentFavorites),
      );
    }
  }

  Future<void> toggleFavorite(Product product) async {
    final currentFavorites = state.value?.favoriteProducts ?? [];
    final isFav = currentFavorites.any((p) => p.id == product.id);

    // 1. Mise à jour instantanée de l'interface utilisateur (Optimistic UI)
    final updatedList = isFav
        ? currentFavorites.where((p) => p.id != product.id).toList()
        : [...currentFavorites, product];

    state = AsyncValue.data(
      FavoriteProductState(favoriteProducts: updatedList),
    );

    // 2. Traitement en arrière-plan dans le repository
    try {
      await _favoriteRepository.toggleFavoriteProduct(product);
    } catch (e) {
      // Si la sauvegarde échoue (ex: erreur réseau),
      //on restaure l'ancienne liste (Rollback)
      state = AsyncValue.data(
        FavoriteProductState(favoriteProducts: currentFavorites),
      );
    }
  }

  Future<void> clearFavorites() async {
    await _favoriteRepository.clearFavorites();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(loadItems);
  }
}
