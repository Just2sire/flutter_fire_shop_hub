import "package:shared_preferences/shared_preferences.dart";
import "package:shop_hub/core/configs/logger.dart";
import "package:shop_hub/core/constants/app_keys.dart";
import "package:shop_hub/data/models/index.dart" show Product, User, CartItem;

/// Service de stockage local basé sur SharedPreferences.
/// Fournit des opérations primitives type-safe et des méthodes métier
/// pour l'application ShopHub.
class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  static SharedPreferences? _instance;

  /// Retourne l'instance unique de [SharedPreferences].
  static Future<SharedPreferences> get instance async {
    return _instance ??= await SharedPreferences.getInstance();
  }

  /// Constructeur usine pour initialiser [LocalStorageService]
  /// de manière asynchrone.
  static Future<LocalStorageService> create() async {
    final prefs = await instance;
    return LocalStorageService(prefs);
  }

  // ==================== OPÉRATIONS PRIMITIVES ====================

  /// Lit une chaîne de caractères enregistrée sous la clé [key].
  String? getString(String key, {String? defaultValue}) {
    try {
      return _prefs.getString(key) ?? defaultValue;
    } catch (e) {
      Log.e(
        "Erreur lecture String pour '$key': $e",
        tag: "LocalStorageService",
      );
      return defaultValue;
    }
  }

  /// Sauvegarde une chaîne de caractères sous la clé [key].
  Future<bool> setString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e) {
      Log.e(
        "Erreur écriture String pour '$key': $e",
        tag: "LocalStorageService",
      );
      return false;
    }
  }

  /// Lit un entier enregistré sous la clé [key].
  int? getInt(String key, {int? defaultValue}) {
    try {
      return _prefs.getInt(key) ?? defaultValue;
    } catch (e) {
      Log.e("Erreur lecture int pour '$key': $e", tag: "LocalStorageService");
      return defaultValue;
    }
  }

  /// Sauvegarde un entier sous la clé [key].
  Future<bool> setInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e) {
      Log.e("Erreur écriture int pour '$key': $e", tag: "LocalStorageService");
      return false;
    }
  }

  /// Lit un nombre décimal enregistré sous la clé [key].
  double? getDouble(String key, {double? defaultValue}) {
    try {
      return _prefs.getDouble(key) ?? defaultValue;
    } catch (e) {
      Log.e(
        "Erreur lecture double pour '$key': $e",
        tag: "LocalStorageService",
      );
      return defaultValue;
    }
  }

  /// Sauvegarde un nombre décimal sous la clé [key].
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _prefs.setDouble(key, value);
    } catch (e) {
      Log.e(
        "Erreur écriture double pour '$key': $e",
        tag: "LocalStorageService",
      );
      return false;
    }
  }

  /// Lit un booléen enregistré sous la clé [key].
  bool getBool(String key, {bool defaultValue = false}) {
    try {
      return _prefs.getBool(key) ?? defaultValue;
    } catch (e) {
      Log.e("Erreur lecture bool pour '$key': $e", tag: "LocalStorageService");
      return defaultValue;
    }
  }

  /// Sauvegarde un booléen sous la clé [key].
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e) {
      Log.e("Erreur écriture bool pour '$key': $e", tag: "LocalStorageService");
      return false;
    }
  }

  /// Lit une liste de chaînes enregistrée sous la clé [key].
  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    try {
      return _prefs.getStringList(key) ?? defaultValue;
    } catch (e) {
      Log.e(
        "Erreur lecture List<String> pour '$key': $e",
        tag: "LocalStorageService",
      );
      return defaultValue;
    }
  }

  /// Sauvegarde une liste de chaînes sous la clé [key].
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _prefs.setStringList(key, value);
    } catch (e) {
      Log.e(
        "Erreur écriture List<String> pour '$key': $e",
        tag: "LocalStorageService",
      );
      return false;
    }
  }

  /// Supprime la clé [key] du stockage local.
  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e) {
      Log.e("Erreur suppression pour '$key': $e", tag: "LocalStorageService");
      return false;
    }
  }

  /// Efface la totalité du stockage local.
  Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      Log.e(
        "Erreur réinitialisation du local storage: $e",
        tag: "LocalStorageService",
      );
      return false;
    }
  }

  /// Vérifie si la clé [key] existe dans le stockage local.
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // ==================== PREMIER LANCEMENT / ONBOARDING ====================

  /// Indique s'il s'agit du premier lancement de l'application.
  bool get isFirstRun => getBool(AppKeys.isFirstRun, defaultValue: true);

  /// Marque le premier lancement comme terminé.
  Future<bool> setFirstRunCompleted() async {
    return setBool(AppKeys.isFirstRun, false);
  }

  // ==================== PROFIL UTILISATEUR / SESSION ====================

  /// Indique si un utilisateur est actuellement sauvegardé.
  bool get hasUser {
    final userString = getString(AppKeys.user);
    return userString != null && userString.trim().isNotEmpty;
  }

  /// Récupère l'utilisateur enregistré.
  User? getUser() {
    try {
      final userString = getString(AppKeys.user);
      if (userString == null || userString.isEmpty) return null;
      return User.fromJson(userString);
    } catch (e) {
      Log.e(
        "Erreur lecture profil utilisateur: $e",
        tag: "LocalStorageService",
      );
      return null;
    }
  }

  /// Sauvegarde le profil [User].
  Future<bool> saveUser(User user) async {
    return setString(AppKeys.user, user.toJson());
  }

  /// Met à jour les informations de l'utilisateur connecté.
  Future<bool> updateUser({
    String? username,
    String? email,
    String? phone,
  }) async {
    final currentUser = getUser() ?? User(username: "", email: "", phone: "");
    final updatedUser = currentUser.copyWith(
      username: username,
      email: email,
      phone: phone,
    );
    return saveUser(updatedUser);
  }

  /// Supprime l'utilisateur enregistré.
  Future<bool> removeUser() async {
    return remove(AppKeys.user);
  }

  // ==================== PRODUITS FAVORIS ====================

  /// Sauvegarde la liste des IDs des produits favoris.
  Future<bool> saveFavoriteIds(List<String> favoriteIds) async {
    return setStringList(AppKeys.favorites, favoriteIds);
  }

  /// Ajoute un produit aux favoris par son ID.
  Future<bool> addFavorite(Product product) async {
    final favorites = getFavoriteProducts();
    if (favorites.contains(product)) return true;
    return saveFavoriteProducts([...favorites, product]);
  }

  /// Supprime un produit des favoris par son ID.
  Future<bool> removeFavorite(Product product) async {
    final favorites = getFavoriteProducts();
    final updated = favorites.where((p) => p != product).toList();
    return saveFavoriteProducts(updated);
  }

  /// Vérifie si un produit est dans les favoris.
  bool isFavorite(Product product) {
    return getFavoriteProducts().contains(product);
  }

  /// Alterne le statut favori d'un produit.
  Future<bool> toggleFavorite(Product product) async {
    if (isFavorite(product)) {
      return removeFavorite(product);
    } else {
      return addFavorite(product);
    }
  }

  /// Récupère la liste des produits favoris sérialisés en JSON.
  List<Product> getFavoriteProducts() {
    try {
      final jsonList = getStringList(AppKeys.favorites);
      if (jsonList == null || jsonList.isEmpty) return [];
      return jsonList.map(Product.fromJson).toList();
    } catch (e) {
      Log.e("Erreur lecture produits favoris: $e", tag: "LocalStorageService");
      return [];
    }
  }

  /// Supprime la liste des produits favoris.
  Future<bool> clearFavoriteProducts() async {
    return remove(AppKeys.favorites);
  }

  /// Sauvegarde la liste complète des objets [Product] favoris.
  Future<bool> saveFavoriteProducts(List<Product> products) async {
    final jsonList = products.map((p) => p.toJson()).toList();
    return setStringList(AppKeys.favorites, jsonList);
  }

  // ==================== PRODUITS PANIER ====================

  /// Récupère la liste des produits du panier depuis le stockage local.
  List<CartItem> getCartItems() {
    try {
      final jsonList = getStringList(AppKeys.cart);
      if (jsonList == null || jsonList.isEmpty) return [];
      return jsonList.map(CartItem.fromJson).toList();
    } catch (e) {
      Log.e("Erreur lecture panier: $e", tag: "LocalStorageService");
      return [];
    }
  }

  /// Sauvegarde la liste complète des objets [CartItem] du panier.
  Future<bool> saveCartItems(List<CartItem> cartItems) async {
    final jsonList = cartItems.map((c) => c.toJson()).toList();
    return setStringList(AppKeys.cart, jsonList.cast<String>());
  }

  /// Ajoute un article au panier.
  Future<bool> addToCart(Product product, [int quantity = 1]) async {
    final cartItems = getCartItems();
    if (cartItems.any((item) => item.product.id == product.id)) return true;
    return saveCartItems([
      ...cartItems,
      CartItem(product: product, quantity: quantity),
    ]);
  }

  /// Supprime un article du panier.
  Future<bool> removeFromCart(Product product) async {
    final cartItems = getCartItems();
    final updated = cartItems
        .where((item) => item.product.id != product.id)
        .toList();
    return saveCartItems(updated);
  }

  /// Vide le panier.
  Future<bool> clearCart() async {
    return saveCartItems([]);
  }

  /// Vérifie si un article est dans le panier.
  bool isCartItem(Product product) {
    return getCartItems().any((item) => item.product.id == product.id);
  }

  /// Alterne le statut panier d'un article.
  Future<bool> toggleCartItem(Product product) async {
    if (isCartItem(product)) {
      return removeFromCart(product);
    } else {
      return addToCart(product);
    }
  }

  /// Récupère le nombre d'articles dans le panier.
  int getCartCount() => getCartItems().length;

  /// Calcule le coût total du panier.
  double getCartTotal() =>
      getCartItems().fold(0, (total, item) => total + item.totalPrice);

  /// Modifier la quantité d'un article dans le panier
  Future<bool> updateCartItemQuantity(Product product, int quantity) async {
    final cartItems = getCartItems();
    final updated = cartItems.map((item) {
      if (item.product.id == product.id) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
    return saveCartItems(updated);
  }

  // ==================== MODE DE THÈME ====================

  /// Récupère le mode de thème enregistré (ex: 'light', 'dark', 'system').
  String? getThemeMode() {
    return getString(AppKeys.themeMode);
  }

  /// Sauvegarde le mode de thème.
  Future<bool> saveThemeMode(String themeMode) async {
    return setString(AppKeys.themeMode, themeMode);
  }
}

/// Classe de compatibilité statique pour faciliter l'accès sans injection.
class SharedPrefsService {
  static Future<LocalStorageService> get _service async {
    final prefs = await LocalStorageService.instance;
    return LocalStorageService(prefs);
  }

  static Future<User> get getUser async {
    final service = await _service;
    return service.getUser() ??
        User(
          username: "John Doe",
          email: "johndoe@gmail.com",
          phone: "90876534",
        );
  }

  static Future<bool> saveUser(User user) async {
    final service = await _service;
    return service.saveUser(user);
  }

  static Future<bool> updateUser({
    String? username,
    String? email,
    String? phone,
  }) async {
    final service = await _service;
    return service.updateUser(username: username, email: email, phone: phone);
  }

  static Future<bool> removeUser() async {
    final service = await _service;
    return service.removeUser();
  }

  static Future<String?> get getThemeMode async {
    final service = await _service;
    return service.getThemeMode();
  }

  static Future<bool> saveThemeMode(String themeMode) async {
    final service = await _service;
    return service.saveThemeMode(themeMode);
  }
}
