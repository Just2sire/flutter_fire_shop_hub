import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shop_hub/data/models/index.dart" show Product, ProductFilter;
import "package:shop_hub/presentation/providers/product_providers.dart";

class ProductState {
  const ProductState({
    this.products = const [],
    this.filteredProducts = const [],
    this.searchQuery = "",
    this.filterParam,
  });
  final List<Product> products;

  final List<Product> filteredProducts;

  final String searchQuery;

  final ProductFilter? filterParam;

  ProductState copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    String? searchQuery,
    ProductFilter? filterParam,
  }) {
    return ProductState(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      filterParam: filterParam ?? this.filterParam,
    );
  }
}

class ProductListNotifier extends AsyncNotifier<ProductState> {
  ProductListNotifier();

  @override
  Future<ProductState> build() async {
    return await loadProducts();
  }

  Future<ProductState> loadProducts({ProductFilter? filter}) async {
    final repository = ref.read(productRepositoryProvider);
    final result = await repository.getProducts(filter: filter);
    return result.fold((failure) => throw Exception(failure.message), (
      loadedProducts,
    ) {
      // Si on n'a pas de filtre (chargement initial ou refresh complet),
      // on met à jour la liste complète 'products'.
      // Sinon, on garde la liste 'products' existante et on ne met à jour
      // que 'filteredProducts'.
      final currentProducts = state.value?.products;

      return ProductState(
        products: filter == null
            ? loadedProducts
            : (currentProducts ?? loadedProducts),
        filteredProducts: loadedProducts,
        filterParam: filter,
      );
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(loadProducts);
  }

  Future<void> filterProducts(ProductFilter filter) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => loadProducts(filter: filter));
  }

  Future<void> filterByCategory(String slug, ProductFilter? filter) async {
    final repository = ref.read(productRepositoryProvider);
    final result = await repository.getProductsByCategory(
      slug: slug,
      filter: filter,
    );
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => result.fold((failure) => throw Exception(failure.message), (
        loadedProducts,
      ) {
        final currentProducts = state.value?.products;

        return ProductState(
          products: currentProducts ?? loadedProducts,
          filteredProducts: loadedProducts,
          filterParam: filter,
        );
      }),
    );
  }
}
