import "package:shop_hub/data/models/product.dart";
import "package:shop_hub/data/services/local_storage_service.dart";
import "package:shop_hub/domain/repositories/favorite_product_repository.dart";

class FavoriteProductRepositoryImpl implements FavoriteProductRepository {
  FavoriteProductRepositoryImpl(this._localStorageService);
  final LocalStorageService _localStorageService;

  @override
  Future<bool> addProductToFavorites(Product product) async {
    return _localStorageService.addFavorite(product);
  }

  @override
  Future<bool> clearFavorites() async {
    return _localStorageService.clearFavoriteProducts();
  }

  @override
  Future<List<Product>> getFavorites() async {
    return _localStorageService.getFavoriteProducts();
  }

  @override
  Future<bool> isFavoriteProduct(Product product) async {
    return _localStorageService.isFavorite(product);
  }

  @override
  Future<bool> removeProductFromFavorites(Product product) async {
    return _localStorageService.removeFavorite(product);
  }

  @override
  Future<bool> toggleFavoriteProduct(Product product) async {
    return _localStorageService.toggleFavorite(product);
  }
}
