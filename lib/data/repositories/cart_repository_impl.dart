import "package:shop_hub/data/models/cart_item.dart";
import "package:shop_hub/data/models/product.dart";
import "package:shop_hub/data/services/local_storage_service.dart";
import "package:shop_hub/domain/repositories/cart_repository.dart";

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl({required this._localStorageService});

  final LocalStorageService _localStorageService;

  @override
  Future<bool> addItem({
    required Product product,
    required int quantity,
  }) async {
    return _localStorageService.addToCart(product, quantity);
  }

  @override
  Future<bool> clearCart() async {
    return _localStorageService.clearCart();
  }

  @override
  Future<List<CartItem>> getCart() async {
    return _localStorageService.getCartItems();
  }

  @override
  Future<bool> removeItem(Product product) async {
    return _localStorageService.removeFromCart(product);
  }

  @override
  Future<bool> updateQuantity({
    required Product product,
    required int quantity,
  }) {
    return _localStorageService.updateCartItemQuantity(product, quantity);
  }

  @override
  Future<bool> toggleCartItem(Product product) {
    return _localStorageService.toggleCartItem(product);
  }
}
