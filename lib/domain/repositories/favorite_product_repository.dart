import "package:shop_hub/data/models/index.dart";

abstract class FavoriteProductRepository {
  Future<List<Product>> getFavorites();
  
  Future<bool> addProductToFavorites(Product product);
  
  Future<bool> removeProductFromFavorites(Product product);

  Future<bool> isFavoriteProduct(Product product);

  Future<bool> toggleFavoriteProduct(Product product);

  Future<bool> clearFavorites();
}
