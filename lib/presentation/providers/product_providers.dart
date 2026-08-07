import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shop_hub/data/datasources/product_local_datasource.dart";
import "package:shop_hub/data/datasources/product_remote_datasource.dart";
import "package:shop_hub/data/models/index.dart" show Category;
import "package:shop_hub/data/models/product.dart" show Product;
import "package:shop_hub/data/repositories/product_repository_impl.dart";
import "package:shop_hub/presentation/providers/http_service_providers.dart";
import "package:shop_hub/presentation/providers/state_providers/product_state.dart";

final productRemoteDataSourceProvider = Provider((ref) {
  return ProductRemoteDatasource(apiService: ref.watch(apiServiceProvider));
});

final productLocalDataSourceProvider = Provider((ref) {
  return ProductLocalDatasource();
});

final productRepositoryProvider = Provider((ref) {
  // final isConnected = ref.watch(networkStatusProvider).value ?? true;
  return ProductRepositoryImpl(
    remoteDatasource: ref.read(productRemoteDataSourceProvider),
    localDatasource: ref.read(productLocalDataSourceProvider),
    isConnected: true, // isConnected,
  );
});

final productListProvider =
    AsyncNotifierProvider<ProductListNotifier, ProductState>(() {
      return ProductListNotifier();
    });

final productDetailProvider = FutureProvider.family<Product, String>((
  ref,
  productId,
) async {
  final repository = ref.read(productRepositoryProvider);
  final result = await repository.getProduct(productId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (product) => product,
  );
});

final productCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  // keepAlive : garde le résultat en cache pour éviter les appels API répétés
  ref.keepAlive();

  final repository = ref.read(productRepositoryProvider);
  final result = await repository.getProductCategories();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (categories) => categories,
  );
});
