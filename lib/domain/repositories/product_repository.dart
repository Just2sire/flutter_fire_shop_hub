import "package:shop_hub/data/models/index.dart" show Product, ProductFilter, Category;

import "../../data/services/http_service/index.dart";

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({ProductFilter? filter});
  Future<Either<Failure, List<Product>>> searchProducts({
    required String query,
  });
  Future<Either<Failure, Product>> getProduct(String id);
  Future<Either<Failure, List<Category>>> getProductCategories();
  Future<Either<Failure, List<Product>>> getProductsByCategory({
    required String slug,
  });
}
