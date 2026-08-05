import "dart:convert";

import "package:flutter/services.dart" show AssetBundle, rootBundle;
import "package:shop_hub/data/services/http_service/index.dart";

import "../models/index.dart" show Category, Product, ProductFilter;

class ProductLocalDatasource {
  ProductLocalDatasource({
    AssetBundle? bundle,
    this.productsAssetPath = "assets/data/products.json",
    this.categoriesAssetPath = "assets/data/categories.json",
  }) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final String productsAssetPath;
  final String categoriesAssetPath;

  Future<Either<Failure, List<Product>>> getProducts({
    ProductFilter? filter,
  }) async {
    try {
      final jsonString = await _bundle.loadString(productsAssetPath);
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic> || decoded["products"] is! List) {
        return left(
          const Failure(
            message: "Format JSON local invalide pour les produits.",
            type: FailureType.invalidResponse,
          ),
        );
      }
      final rawList = decoded["products"] as List;
      final products = rawList
          .map((item) => Product.fromMap(item as Map<String, dynamic>))
          .toList();

      final result = filter != null ? filter.apply(products) : products;
      return right(result);
    } catch (e) {
      return left(
        Failure(
          message: "Erreur lors du chargement des produits locaux : $e",
          type: FailureType.unknown,
        ),
      );
    }
  }

  Future<Either<Failure, List<Product>>> searchProducts({
    required String query,
  }) async {
    final filter = ProductFilter(searchQuery: query);
    return await getProducts(filter: filter);
  }

  Future<Either<Failure, Product>> getProduct(String id) async {
    final productsResult = await getProducts();
    return productsResult.fold(
      (failure) => left<Failure, Product>(failure),
      (products) {
        final parsedId = int.tryParse(id);
        final matches = products.where(
          (p) => p.id == parsedId || p.id.toString() == id,
        );
        if (matches.isEmpty) {
          return left<Failure, Product>(
            const Failure(
              message: "Produit non trouvé.",
              type: FailureType.notFound,
            ),
          );
        }
        return right<Failure, Product>(matches.first);
      },
    );
  }

  Future<Either<Failure, List<Category>>> getProductCategories() async {
    try {
      final jsonString = await _bundle.loadString(categoriesAssetPath);
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is! List) {
        return left(
          const Failure(
            message: "Format JSON local invalide pour les catégories.",
            type: FailureType.invalidResponse,
          ),
        );
      }
      final categories = decoded
          .map((item) => Category.fromMap(item as Map<String, dynamic>))
          .toList();
      return right(categories);
    } catch (e) {
      return left(
        Failure(
          message: "Erreur lors du chargement des catégories locales : $e",
          type: FailureType.unknown,
        ),
      );
    }
  }

  Future<Either<Failure, List<Product>>> getProductsByCategory({
    required String slug,
    ProductFilter? filter,
  }) async {
    final categoryFilter = (filter ?? const ProductFilter()).copyWith(
      category: slug,
    );
    return await getProducts(filter: categoryFilter);
  }
}
