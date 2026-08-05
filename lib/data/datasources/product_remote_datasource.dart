import "package:shop_hub/core/constants/api_endpoints.dart";
import "package:shop_hub/data/services/http_service/index.dart";

import "../models/index.dart" show Product, ProductFilter, Category;

class ProductRemoteDatasource {
  ProductRemoteDatasource({required this._apiService});
  final ApiService _apiService;

  Future<Either<Failure, List<Product>>> getProducts({
    ProductFilter? filter,
  }) async {
    final result = await _apiService.get<List<Product>>(
      ApiEndpoints.products,
      queryParameters: filter?.toQueryParams(),
      parser: (json) {
        if (json["products"] is! List) {
          throw const FormatException(
            "La réponse de l'API n'est pas une liste.",
          );
        }
        return (json["products"] as List)
            .map((item) => Product.fromMap(item as Map<String, dynamic>))
            .toList();
      },
    );
    return result;
  }

  Future<Either<Failure, List<Product>>> searchProducts({
    required String query,
  }) async {
    final result = await _apiService.get<List<Product>>(
      "${ApiEndpoints.searchProducts}?q=$query",
      parser: (json) {
        if (json["products"] is! List) {
          throw const FormatException(
            "La réponse de l'API n'est pas une liste.",
          );
        }
        return (json["products"] as List)
            .map((item) => Product.fromMap(item as Map<String, dynamic>))
            .toList();
      },
    );
    return result;
  }

  Future<Either<Failure, Product>> getProduct(String id) async {
    final result = await _apiService.get<Product>(
      "${ApiEndpoints.products}/$id",
      parser: Product.fromMap,
    );

    return result;
  }

  Future<Either<Failure, List<Category>>> getProductCategories() async {
    final result = await _apiService.get<List<Category>>(
      ApiEndpoints.categories,
      parser: (json) {
        if (json is! List) {
          throw const FormatException(
            "La réponse de l'API n'est pas une liste.",
          );
        }
        return (json as List)
            .map((item) => Category.fromMap(item as Map<String, dynamic>))
            .toList();
      },
    );

    return result;
  }

  Future<Either<Failure, List<Product>>> getProductsByCategory({
    required String slug,
    ProductFilter? filter,
  }) async {
    final result = await _apiService.get<List<Product>>(
      "${ApiEndpoints.categories}/$slug",
      queryParameters: filter?.toQueryParams(),
      parser: (json) {
        if (json["products"] is! List) {
          throw const FormatException(
            "La réponse de l'API n'est pas une liste.",
          );
        }
        return (json["products"] as List)
            .map((item) => Product.fromMap(item as Map<String, dynamic>))
            .toList();
      },
    );
    return result;
  }
}
