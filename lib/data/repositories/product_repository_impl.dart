import "package:shop_hub/data/datasources/product_local_datasource.dart";
import "package:shop_hub/data/datasources/product_remote_datasource.dart";
import "package:shop_hub/data/models/index.dart"
    show Product, ProductFilter, Category;
import "package:shop_hub/data/services/http_service/index.dart"
    show Either, Failure;
import "package:shop_hub/domain/repositories/product_repository.dart";

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.isConnected,
  });

  final ProductLocalDatasource localDatasource;
  final ProductRemoteDatasource remoteDatasource;
  final bool isConnected;

  @override
  Future<Either<Failure, Product>> getProduct(String id) async {
    if (isConnected) return remoteDatasource.getProduct(id);
    return localDatasource.getProduct(id);
  }

  @override
  Future<Either<Failure, List<Category>>> getProductCategories() async {
    if (isConnected) return remoteDatasource.getProductCategories();
    return localDatasource.getProductCategories();
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    ProductFilter? filter,
  }) async {
    if (isConnected) return remoteDatasource.getProducts(filter: filter);
    return localDatasource.getProducts(filter: filter);
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory({
    required String slug,
    ProductFilter? filter,
  }) async {
    if (isConnected) {
      return remoteDatasource.getProductsByCategory(slug: slug, filter: filter);
    }
    return localDatasource.getProductsByCategory(slug: slug, filter: filter);
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts({
    required String query,
  }) async {
    if (isConnected) return remoteDatasource.searchProducts(query: query);
    return localDatasource.searchProducts(query: query);
  }
}
