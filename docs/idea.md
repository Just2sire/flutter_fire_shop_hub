# 🛒 E-Commerce Riverpod — Option 2 Complète + Architecture

## Vue d'Ensemble du Projet

**ShopHub** : Une vraie app e-commerce fonctionnelle, pas juste un catalogue.

**Scope ambitieux mais réaliste :**
- Catalogue avec pagination
- Panier persisté
- Favoris sophistiqués (collections multiples)
- Filtrage/recherche intelligents
- Système d'avis intégré
- Checkout réaliste
- Profil avec analytics
- Animations cohérentes

**Stack technique :**
- Riverpod (state management)
- Fakestore API Platzi (produits réels)
- SharedPreferences (persistance locale)
- Architecture en couches (Models → Services → Providers → UI)

---

## 🏗️ Architecture en Couches

```
lib/
├── config/
│   ├── routing/                    ← Routes GoRouter + transitions
│   ├── theme/                      ← ThemeData light/dark
│   └── constants.dart              ← URLs API, constantes globales
│
├── models/                         ← Pure data classes (pas de logique)
│   ├── product.dart               ← Product (id, titre, prix, etc.)
│   ├── cart_item.dart             ← CartItem (product + quantity)
│   ├── favorite_collection.dart    ← FavoriteCollection (liste nommée)
│   ├── order.dart                 ← Order (confirmation)
│   ├── review.dart                ← Review (avis utilisateur)
│   └── user.dart                  ← User (mock, données profil)
│
├── services/                       ← Logique métier (pas Riverpod)
│   ├── api/
│   │   └── fakestore_api.dart     ← Appels HTTP directs, pas de state
│   ├── local/
│   │   ├── storage_service.dart   ← SharedPreferences wrapper
│   │   └── analytics_service.dart ← Tracker local d'événements
│   └── validators.dart            ← Validation (email, prix, etc.)
│
├── providers/                      ← Riverpod providers (STATE MANAGEMENT)
│   ├── products_provider.dart      ← ProductsNotifier + StateNotifierProvider
│   ├── cart_provider.dart          ← CartNotifier + StateNotifierProvider
│   ├── favorites_provider.dart     ← FavoritesNotifier + StateNotifierProvider
│   ├── reviews_provider.dart       ← ReviewsNotifier + StateNotifierProvider
│   ├── filters_provider.dart       ← FiltersNotifier + StateNotifierProvider (recherche + tri)
│   ├── user_provider.dart          ← UserNotifier (mock profil)
│   ├── orders_provider.dart        ← OrdersNotifier (historique commandes)
│   ├── analytics_provider.dart     ← AnalyticsProvider (computed state)
│   └── combined_providers.dart     ← Computed providers (combinent d'autres)
│
├── screens/
│   ├── home_screen.dart            ← Accueil : catalogue + filtres
│   ├── product_detail_screen.dart  ← Détail produit + avis + ajout panier
│   ├── cart_screen.dart            ← Panier : liste items + total
│   ├── checkout_screen.dart        ← Adresse + paiement
│   ├── order_confirmation_screen.dart  ← Confirmation post-paiement
│   ├── favorites_screen.dart       ← Collections de favoris
│   ├── profile_screen.dart         ← Profil + analytics + historique
│   ├── search_screen.dart          ← Recherche avancée + filtres
│   └── order_history_screen.dart   ← Mes commandes
│
├── widgets/                        ← Composants réutilisables (stateless)
│   ├── product_card.dart           ← Carte produit avec image, prix, note
│   ├── cart_item_tile.dart         ← Item du panier avec quantité
│   ├── filter_chip_group.dart      ← Groupe de filtres
│   ├── price_range_slider.dart     ← Slider prix min/max
│   ├── rating_display.dart         ← Étoiles + nombre avis
│   ├── loading_skeleton.dart       ← Shimmer loading
│   ├── error_widget.dart           ← Affichage erreur + retry
│   └── app_bar_custom.dart         ← AppBar réutilisable
│
├── utils/
│   ├── extensions.dart             ← Extensions (String, num, etc.)
│   ├── formatters.dart             ← Formatage (devise, date, etc.)
│   └── decorations.dart            ← InputDecoration réutilisables
│
└── main.dart                       ← Entry point + ProviderScope
```

---

## 🔌 Riverpod Providers — Le Cœur du Projet

### **Structure Générale**

Chaque provider suit ce pattern :
```
1. State class (données)
2. Notifier class (logique qui modifie l'état)
3. StateNotifierProvider (expose le notifier)
4. Computed providers (combinent d'autres providers)
```

### **Provider #1 : ProductsNotifier + products_provider**

**Rôle** : Gère le catalogue de produits (fetch, pagination, caching)

**État** :
```
class ProductsState {
  List<Product> products
  bool isLoading
  String? error
  int currentPage
  bool hasMoreProducts
}
```

**Opérations** :
- `fetchProducts(page)` : charge produits par page depuis Platzi API
- `clearCache()` : vide le cache (pull-to-refresh)
- Cache en mémoire (évite re-requêtes inutiles)

**Provider** :
```
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>
```

**Utilisation UI** :
```dart
// Dans un widget
final productsState = ref.watch(productsProvider);
productsState.when(
  data: (products) => GridView(items: products),
  loading: () => LoadingShimmer(),
  error: (err) => ErrorWidget(),
);
```

---

### **Provider #2 : CartNotifier + cart_provider**

**Rôle** : Gère le panier (ajout, suppression, quantité, persistance)

**État** :
```
class CartState {
  List<CartItem> items
  double totalPrice
  int itemCount
}
```

**Opérations** :
- `addItem(product, quantity)` : ajoute au panier (ou ++) si existe
- `removeItem(productId)` : supprime complètement
- `updateQuantity(productId, newQuantity)` : change la quantité
- `clearCart()` : vide tout
- Persiste en SharedPreferences à chaque changement

**Provider** :
```
final cartProvider = StateNotifierProvider<CartNotifier, CartState>
```

**Logique Spéciale** :
- Si l'utilisateur ajoute un produit qui existe → `quantity++` au lieu de dupliquer
- `totalPrice` est calculé automatiquement (List<CartItem>.fold())

---

### **Provider #3 : FavoritesNotifier + favorites_provider**

**Rôle** : Système de favoris sophistiqué (collections multiples)

**État** :
```
class FavoritesState {
  List<FavoriteCollection> collections
  // Une FavoriteCollection = { name, List<Product>, createdAt }
}
```

**Opérations** :
- `createCollection(name)` : crée une nouvelle collection ("À acheter", "Cadeaux", etc.)
- `addToCollection(collectionId, product)` : ajoute un produit à une collection
- `removeFromCollection(collectionId, productId)` : retire
- `deleteCollection(collectionId)` : supprime une collection entière
- `renameCollection(collectionId, newName)` : renomme

**Provider** :
```
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, FavoritesState>
```

**Bonus** :
- Partage : génère URL/texte shareable d'une collection
- Historique : chaque collection tracks quand elle a été créée et modifiée

---

### **Provider #4 : FiltersNotifier + filters_provider**

**Rôle** : État transitoire de filtrage/recherche (combinable avec d'autres providers)

**État** :
```
class FiltersState {
  String searchQuery
  List<String> selectedCategories
  double minPrice, maxPrice
  double minRating
  String sortBy // "price_asc", "price_desc", "rating", "newest"
}
```

**Opérations** :
- `setSearchQuery(query)` : tape recherche
- `toggleCategory(category)` : select/deselect catégorie
- `setPriceRange(min, max)` : slider prix
- `setMinRating(rating)` : voir que 4+ étoiles
- `setSortBy(sortType)` : change tri

**Provider** :
```
final filtersProvider = StateNotifierProvider<FiltersNotifier, FiltersState>
```

**Logique** :
- Pas de recherche immédiate → les filtres juste changent l'état
- La recherche se fait via un **computed provider** qui combine `productsProvider` + `filtersProvider`

---

### **Provider #5 : ReviewsNotifier + reviews_provider**

**Rôle** : Gère les avis clients sur les produits

**État** :
```
class ReviewsState {
  Map<int, List<Review>> reviewsByProductId
  // Review = { userId, productId, rating (1-5), text, date }
}
```

**Opérations** :
- `addReview(productId, rating, text)` : crée un avis
- `getReviewsForProduct(productId)` : récupère avis du produit
- `getMyReviewForProduct(productId)` : ma propre note si j'ai noté
- Persiste en SharedPreferences

**Provider** :
```
final reviewsProvider = StateNotifierProvider<ReviewsNotifier, ReviewsState>
```

---

### **Provider #6 : UserNotifier + user_provider**

**Rôle** : Mock profil utilisateur + données de session

**État** :
```
class UserState {
  String? userId
  String name
  String email
  String avatar
  String address
  String paymentMethod
}
```

**Opérations** :
- `updateProfile(name, email, address, etc.)` : modifie le profil
- `setPaymentMethod(method)` : sauvegarde préférence paiement
- Persiste en SharedPreferences

**Provider** :
```
final userProvider = StateNotifierProvider<UserNotifier, UserState>
```

**Mock Initial** :
```
UserState(
  name: "Ahmed Mohamed",
  email: "ahmed@example.com",
  avatar: "assets/avatar.png",
  address: "Lomé, Togo",
  paymentMethod: "credit_card"
)
```

---

### **Provider #7 : OrdersNotifier + orders_provider**

**Rôle** : Historique des commandes passées

**État** :
```
class OrdersState {
  List<Order> orders
  // Order = { id, cartItems, totalPrice, date, status, trackingNumber }
}
```

**Opérations** :
- `createOrder(cartItems, shippingAddress)` : crée commande après checkout
- `getOrderHistory()` : récupère toutes les commandes
- Persiste en SharedPreferences

**Provider** :
```
final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>
```

---

### **Computed Providers** (Magique Riverpod)

Ces providers combinent d'autres providers sans état propre :

#### **filtered_products_provider**
Combine `productsProvider` + `filtersProvider` → retourne produits filtrés/triés
```
final filteredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider).value ?? [];
  final filters = ref.watch(filtersProvider);
  
  // Applique recherche, catégories, prix, rating, tri
  return _applyFilters(products, filters);
});
```

#### **cart_total_provider**
Combine `cartProvider` → retourne total automatiquement recalculé
```
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
});
```

#### **product_average_rating_provider**
Combine `reviewsProvider` + productId → retourne note moyenne du produit
```
final productAverageRatingProvider = Provider.family<double, int>((ref, productId) {
  final reviews = ref.watch(reviewsProvider).reviewsByProductId[productId] ?? [];
  if (reviews.isEmpty) return 0;
  return reviews.map((r) => r.rating).fold(0, (a, b) => a + b) / reviews.length;
});
```

#### **analytics_provider**
Combine `ordersProvider` + `reviewsProvider` → dashboard stats
```
final analyticsProvider = Provider<AnalyticsData>((ref) {
  final orders = ref.watch(ordersProvider).orders;
  final reviews = ref.watch(reviewsProvider).reviewsByProductId;
  
  return AnalyticsData(
    totalSpent: orders.fold(0, (sum, o) => sum + o.totalPrice),
    favoriteCategory: _mostBoughtCategory(orders),
    productsViewed: _getTrackedViews(), // Depuis analytics_service
    averageRating: _calcAverageRating(reviews),
  );
});
```

---

## 📱 Écrans Détaillés

### **1. HomeScreen (Accueil + Catalogue)**

**Composants** :
- AppBar avec logo + search button + cart icon
- Horizontal scroll catégories (filtrage)
- Filtres avancés (prix range, rating min, tri)
- GridView produits avec pagination (infinite scroll)
- Chaque produit = `ProductCard` réutilisable

**State Riverpod utilisé** :
- `productsProvider` (pour les produits)
- `filtersProvider` (pour les filtres sélectionnés)
- `filteredProductsProvider` (computed)
- `cartProvider` (pour afficher nombre items)

**Interactions** :
- Tap catégorie → met à jour `filtersProvider`
- Scroll à la fin → `ref.read(productsProvider.notifier).fetchNextPage()`
- Tap produit → navigate à ProductDetailScreen avec productId
- Tap cart icon → navigate CartScreen

---

### **2. ProductDetailScreen**

**Reçoit en paramètre** : `productId`

**Composants** :
- Image carousel du produit
- Titre + prix + catégorie
- Note moyenne (rating stars + nombre avis)
- Description longue
- **Avis clients** (liste scrollable) :
  - Chaque avis = photo utilisateur + nom + rating + texte + date
  - Si pas d'avis → message "Sois le premier à noter!"
- **Ma propre note** (si j'ai noté ce produit) :
  - 5 étoiles cliquables pour noter (0-5)
  - Champ texte pour mon avis
- Boutons en bas :
  - "Ajouter au panier" (quantité avec ++ et --)
  - "Ajouter aux favoris" (ouvre modal pour choisir collection)

**State Riverpod utilisé** :
- `productsProvider` (pour les données produit)
- `reviewsProvider` (pour les avis)
- `productAverageRatingProvider` (computed, note moyenne)
- `cartProvider` (pour ajouter)
- `favoritesProvider` (pour favoris)

**Interactions** :
- Tap étoile rating → appel `ref.read(reviewsProvider.notifier).addReview(productId, rating, text)`
- Tap "Ajouter au panier" → appel `ref.read(cartProvider.notifier).addItem(product, quantity)`
- Tap "Favoris" → modal liste des collections (ou "Créer nouvelle")

---

### **3. CartScreen**

**Composants** :
- Liste des items du panier (chaque item = `CartItemTile` réutilisable)
  - Image produit (petit)
  - Nom + prix unitaire
  - Quantité avec boutons ++ et --
  - Prix ligne (prix unitaire × quantité)
  - Bouton poubelle pour supprimer
- Résumé bas :
  - Sous-total
  - Frais de port (mock : 5€)
  - **Total** (gros texte)
- Boutons :
  - "Continuer shopping" (navigate Home)
  - "Passer la commande" (navigate Checkout)
- Si panier vide → message + bouton "Continuer shopping"

**State Riverpod utilisé** :
- `cartProvider` (pour les items)
- `cartTotalProvider` (computed, total auto-recalculé)

**Interactions** :
- Tap ++ → `ref.read(cartProvider.notifier).updateQuantity(productId, newQty)`
- Tap -- → idem
- Tap poubelle → `ref.read(cartProvider.notifier).removeItem(productId)`
- Tap "Passer commande" → navigate CheckoutScreen

---

### **4. CheckoutScreen (Nouveau, Bonus)**

**C'est ce qui transforme l'exo d'une app de catalogue en vraie e-commerce.**

**Composants - Step 1 : Adresse**
- Formulaire validation :
  - Nom complet
  - Adresse ligne 1
  - Adresse ligne 2 (optionnel)
  - Ville
  - Code postal
  - Pays
- Bouton "Continuer vers paiement"

**Composants - Step 2 : Paiement**
- Radio buttons pour méthode de paiement :
  - Carte crédit (champs card, expiry, CVV — mock)
  - PayPal (mock, juste affiche "Redirection PayPal")
  - Apple Pay (mock)
- Résumé commande (panier + total)
- Bouton "Confirmer et payer"

**Composants - Step 3 : Confirmation (Page Séparée)**
- Checkmark success animation
- Numéro de commande (généré UUID)
- "Merci pour ton achat!"
- Résumé : items, adresse, total
- "Numéro de suivi : XYZ" (mock UUID)
- Boutons :
  - "Retour à l'accueil"
  - "Voir mes commandes"

**State Riverpod utilisé** :
- `userProvider` (pour pré-remplir adresse)
- `cartProvider` (pour les items)
- `ordersProvider` (pour créer ordre)

**Logique Spéciale** :
- Au tap "Confirmer et payer" :
  1. Valide le formulaire adresse
  2. Crée un `Order` object
  3. `ref.read(ordersProvider.notifier).createOrder(cartItems, shippingAddress)`
  4. `ref.read(cartProvider.notifier).clearCart()` (panier vidé)
  5. Navigate à OrderConfirmationScreen avec le nouvel Order ID
  6. Persiste en SharedPreferences

---

### **5. FavoritesScreen (Nouveau, Bonus)**

**Affiche toutes les collections de favoris** :
- Chaque collection = carte cliquable :
  - Titre collection
  - Nombre de produits
  - Premiers produits (grid 3-4 produits petit)
  - Options : partager, renommer, supprimer
- Bouton "Créer collection" en haut (+ FAB)

**Tap sur une collection** → navigate `FavoriteCollectionDetailScreen`

**FavoriteCollectionDetailScreen** :
- Titre collection + options renommer/supprimer
- GridView produits de la collection
- Chaque produit = ProductCard clickable
- Bouton "Partager cette liste" :
  - Génère URL shareable (mock: "https://shophub.com/favorites/abc123")
  - Génère texte texte à copier : "Voici ma liste de favoris: Produit1 (10€), Produit2 (20€)..."
  - Share via WhatsApp, Twitter, SMS (platform channels)

**State Riverpod utilisé** :
- `favoritesProvider`

---

### **6. ProfileScreen (Dashboard + Analytics)**

**Sections** :

**Section 1 : Infos Utilisateur**
- Avatar
- Nom + email
- Adresse
- Bouton "Éditer profil" (navigate écran form simple)

**Section 2 : Analytics/Dashboard**
- Cartes stats :
  - Total dépensé (€)
  - Nombre commandes
  - Moyenne dépense par commande
  - Produits avec meilleure note
  - Catégorie favorite
- Graphe simple (barres) : dépenses par mois (derniers 6 mois)

**Section 3 : Actions**
- Historique de commandes (click → DetailScreen)
- Mes avis (produits que j'ai notés)
- Méthode de paiement par défaut

**State Riverpod utilisé** :
- `userProvider`
- `ordersProvider`
- `reviewsProvider`
- `analyticsProvider` (computed)

---

### **7. SearchScreen (Avancée, Bonus)**

**Écran dédié à la recherche sophistiquée** :
- Champ recherche large en haut
- Filtres avancés :
  - Catégories (checkbox multiple)
  - Prix range slider
  - Rating minimum
  - Trier par (dropdown)
- Résultats en temps réel (GridView)
- Historique de recherches récentes (clickables)

**State Riverpod utilisé** :
- `filtersProvider`
- `filteredProductsProvider`

---

## ✨ Features Bonus Détaillées

### **A. Collections de Favoris Sophistiquées**

**Pourquoi c'est mieux qu'un simple "favoris"** :
- User peut créer plusieurs listes (À acheter, Cadeaux, Wishlist, etc.)
- Chaque collection a un nom, une date de création, un nombre d'items
- Partage : génère URL ou texte à copier
- Analytics : "Collection la plus grande", "Catégorie dominante par collection"

**Persistance** :
- SharedPreferences sauvegarde la structure entière `FavoritesState`
- Format : JSON string de la liste de collections

---

### **B. Système d'Avis Complet**

**Composants** :
- Affichage des avis d'autres utilisateurs (mock : 5-10 avis par produit)
- Ma propre note (si j'ai noté)
- Statistiques : nombre d'avis, distribution (5 étoiles: 10, 4 étoiles: 5, etc.)
- Filtrer produits par rating min

**Mock Data** :
```
reviews_data.dart contient avis pré-générés par produit
Exemple :
- Produit "Laptop" :
  - Avis 1: "Super qualité! 5 stars" by "Ahmed"
  - Avis 2: "Bon rapport qualité/prix. 4 stars" by "Fatima"
  - etc.
```

**Persistance** :
- Ma propre note pour un produit = persiste en SharedPreferences
- Avis autres utilisateurs = fournis par les données mock (pas d'API pour ça)

---

### **C. Filtrage Intelligent Multi-Critères**

**Combinables** :
- Recherche texte (titre + description)
- Catégories (multi-select)
- Prix range (slider min/max)
- Rating minimum (affiche que 4+, 3+, etc.)
- Tri (prix asc/desc, rating, newest)

**Persistence des filtres** :
- `filtersProvider` persiste l'état (partiel : query + selected categories + sortBy)
- L'utilisateur revient à la page → voit ses filtres précédents

---

### **D. Analytics dans Profil**

**Dashboard stats calculées** :
- Total dépensé (sum de toutes les commandes)
- Nombre de commandes
- Dépense moyenne par commande
- Catégorie la plus achetée
- Produit avec meilleure note (que j'ai noté)
- Graphe dépenses par mois (derniers 6 mois, mock : barres simples)

**Données sources** :
- `ordersProvider` (pour dépenses + commandes)
- `reviewsProvider` (pour mes notes)
- `analyticsService` (pour tracker les vues, events)

---

### **E. Tracking d'Événements Interne**

**Analytics Service Tracks** :
- Produits consultés (date + productId)
- Produits ajoutés au panier (date + productId + quantity)
- Produits achetés (via `createOrder`)
- Produits notés (date + productId + rating)

**Utilisé pour** :
- Dashboard : "Catégorie favorite" (basé sur vues + achats)
- Dashboard : "Produits avec meilleure note"
- Historique : affichage timeline

---

## 📘 Architecture du README (Très Important)

Le README doit être **pédagogique** : quelqu'un qui lit doit comprendre pourquoi tu as fait ces choix.

### **Structure du README**

#### **1. Vue d'ensemble**
```
# ShopHub — E-Commerce App with Riverpod

Une application e-commerce fully-featured construite avec Flutter et Riverpod, 
montrant une architecture scalable et une gestion d'état sophistiquée.

**Features principales** :
- Catalogue de produits avec pagination (Platzi API)
- Panier persisté et checkout réaliste
- Collections de favoris multiples avec partage social
- Système d'avis intégré
- Filtrage multi-critères + recherche full-text
- Profil utilisateur avec analytics de dépenses
- Thème clair/sombre
```

#### **2. Architecture & Design Decisions**

**Sous-section : Layered Architecture**
```
Pourquoi cette séparation ? :

lib/models/          → Immutable data classes (pas de logique)
lib/services/        → Logique métier indépendante de Riverpod
lib/providers/       → Riverpod state management
lib/screens/         → UI consomme providers
lib/widgets/         → Composants réutilisables (stateless)

AVANTAGE : Chaque couche peut être testée indépendamment.
Si j'échange SharedPreferences pour Hive, j'edite que storage_service.dart.
```

**Sous-section : Riverpod vs autres**
```
Pourquoi Riverpod et pas Provider/GetX/MobX ?

1. Type Safety        → Pas de getString("key"), tout typer
2. Computed Providers → Combine d'autres providers automatiquement
3. Invalidation       → Facile invalider des providers (ref.refresh)
4. Testing            → Facile créer des mocks de providers
5. Scoping            → Family providers (filteredProductsProvider.family)
```

#### **3. Providers Détaillés**

**Pour chaque provider, expliquer** :
- **Nom & rôle**
- **État qu'il contient**
- **Opérations (méthodes du Notifier)**
- **Où c'est utilisé**
- **Exemple d'utilisation dans l'UI**

```
### ProductsNotifier + products_provider

**Rôle** : Gère le catalogue de produits (fetch depuis Platzi API + cache)

**État** :
- List<Product> products
- bool isLoading
- String? error
- int currentPage
- bool hasMoreProducts

**Opérations** :
- fetchProducts(int page) → charge produits page par page
- clearCache() → vide le cache (pull-to-refresh)

**Utilisé par** :
- HomeScreen → affiche produits
- filteredProductsProvider → combine avec filters

**Exemple UI** :
```dart
final productsState = ref.watch(productsProvider);
productsState.when(
  data: (state) => GridView(items: state.products),
  loading: () => LoadingShimmer(),
  error: (err, _) => ErrorWidget(message: err.toString()),
);
```

**Caching Strategy** :
- Produits chargés une fois par page, gardés en mémoire
- Pas re-fetch si page déjà chargée
- `clearCache()` force re-fetch (pull-to-refresh)
```

#### **4. Data Flow Diagrams**

**Diagrammes textuels clairs** :

```
USER ADDS PRODUCT TO CART
────────────────────────────
HomeScreen
  → Tap ProductCard
  → Navigate ProductDetailScreen(productId)
ProductDetailScreen
  → Tap "Ajouter au panier" with quantity
  → ref.read(cartProvider.notifier).addItem(product, quantity)
cartProvider (CartNotifier)
  → Check if product already in cart
  → If yes: cartItem.quantity++
  → If no: add new CartItem
  → Recalculate totalPrice
  → Persist state to SharedPreferences
  → notify listeners
UI Rebuild
  → CartScreen watches cartProvider
  → Shows updated cart with new item
  → cartTotalProvider recalculates automatically
```

```
USER CREATES FAVORITE COLLECTION & SHARES
──────────────────────────────────────────
FavoritesScreen
  → Tap "Créer collection"
  → showDialog(name: "Cadeaux")
FavoritesNotifier
  → createCollection("Cadeaux")
  → Adds to favoritesState.collections
  → Persist to SharedPreferences
  → notify listeners
FavoriteCollectionDetailScreen
  → User adds products to collection
  → ref.read(favoritesProvider.notifier).addToCollection(collectionId, product)
  → Tap "Partager"
  → showShareDialog()
  → Generates URL: "shophub://favorites/abc123"
  → Generates Text: "Voici ma liste 'Cadeaux': ..."
  → Share via platform (WhatsApp, Twitter, etc.)
```

#### **5. Features Bonus Explained**

**Pourquoi chaque feature bonus** :

```
### Collections de Favoris Multiples

**Problem** : Un simple bouton "favorite" ne suffit pas.
Utilisateur veut organiser ses envies par liste.

**Solution** :
- Créer n collections ("À acheter", "Cadeaux", "Wishlist")
- Chaque collection est une FavoriteCollection(name, products, createdAt)
- Stockée en SharedPreferences via JSON

**Impact** :
- Montre que j'ai pensé UX réelle (pas juste les requis min)
- Riverpod doit gérer une liste de collections + opérations dessus
- Partage social = feature advanced (platform channels mock)

### Checkout Réaliste

**Problem** : S'arrêter au panier, c'est pas un vrai e-commerce.

**Solution** :
- CheckoutScreen avec formulaire adresse
- SelectPaymentMethod (mock: card, PayPal, Apple Pay)
- OrderConfirmationScreen avec numéro de suivi
- Persiste orders en SharedPreferences
- Orders visibles en profil

**Impact** :
- Montre workflow complet
- Validation de formulaire
- Gestion d'erreurs (adresse invalide, etc.)

### System d'Avis

**Problem** : Produits sans feedback d'autres utilisateurs, c'est plat.

**Solution** :
- Mock data : 5-10 avis par produit
- Ma propre note (persiste)
- Statistiques : nombre avis, distribution
- Filter par rating min

**Impact** :
- ReviewsNotifier = logique métier réaliste
- Computed providers pour moyenne rating
- Montre pensée product complète
```

#### **6. State Management Flows**

```
### Recherche & Filtrage (Computed Provider Excellence)

L'utilisateur :
1. Tape recherche "laptop"
   → filtersProvider.setSearchQuery("laptop")
2. Sélectionne catégorie "Electronics"
   → filtersProvider.toggleCategory("electronics")
3. Met slider prix 100-500€
   → filtersProvider.setPriceRange(100, 500)
4. Filtre par rating 4+
   → filtersProvider.setMinRating(4)

CE QUI SE PASSE SOUS LE CAPOT (magique Riverpod) :

filtersProvider → state changes
  ↓ (watched by)
filteredProductsProvider (computed) → fonction qui applique tous les filtres
  ↓ (watched by)
HomeScreen → rebuild avec produits filtrés

AVANTAGE : Le filtering logic est dans **un seul endroit** (computedProvider).
Pas de spaghetti code "if category && if price && if rating".
```

#### **7. Testing Strategy** (Optional mais Bonus)

```
### Comment Tester ce Projet

**Unit tests** :
- CartNotifier : addItem, removeItem, quantity logic
- FavoritesNotifier : createCollection, addToCollection
- ReviewsNotifier : addReview, getRatingsForProduct

**Widget tests** :
- ProductCard renders correctly
- CartItemTile buttons work

**Integration** :
- Tap product → add to cart → cart updates
- Add to favorites → collection persists → reopen app → collection still there

**Riverpod Testing** :
```dart
test('Cart total recalculates on quantity change', () {
  final container = ProviderContainer();
  final cart = container.read(cartProvider.notifier);
  
  cart.addItem(product, 2);
  var total = container.read(cartTotalProvider);
  expect(total, equals(100)); // 50€ × 2
  
  cart.updateQuantity(product.id, 3);
  total = container.read(cartTotalProvider);
  expect(total, equals(150)); // 50€ × 3
});
```
```

#### **8. Setup & Instructions**

```
## Installation

\`\`\`bash
git clone https://github.com/yourname/shophub.git
cd shophub
flutter pub get
flutter run
\`\`\`

**Requirements** :
- Flutter 3.10+
- Dart 3.0+

**Environment Setup** :
- No API keys needed (Platzi API est public)
- SharedPreferences persiste automatiquement
- Fakestore API : https://fakeapi.platzi.com/en
```

#### **9. Packages Utilisés**

```
## Dependencies

**State Management** :
- riverpod & flutter_riverpod (state management)

**Networking** :
- http (fetch depuis Platzi API)

**Persistence** :
- shared_preferences (favoris, cart, orders, user)

**Navigation** :
- go_router (routing)

**UI/UX** :
- intl (date/currency formatting)
- connectivity_plus (check internet, optional)

**Dev** :
- riverpod_generator (optional, pour code generation)
```

#### **10. Project Metrics**

```
## Stats du Projet

**Fichiers** :
- 15 models
- 8 providers
- 8 screens
- 10 widgets réutilisables
- 3 services (API, storage, analytics)

**Lines of Code** :
- ~3000 LOC (sans commentaires)
- ~500 LOC pour les providers (état management)
- ~1500 LOC pour les UI

**Features** :
- 8 écrans
- 5 collections de favoris possible
- Pagination catalogue
- Filtrage multi-critères
- Système avis complet
- Checkout réaliste
- Analytics + dashboard
- Thème light/dark

**Riverpod Mastery** :
- 8 StateNotifierProviders
- 3+ Computed Providers
- Family providers (productAverageRatingProvider.family)
- AsyncValue handling (loading, error, data)
- StateNotifier combining multiple providers
```

#### **11. Architecture Diagram (Texte ASCII)**

```
      USER INTERACTIONS
            ↓
      SCREENS (UI Layer)
            ↓
      watch() ref.read() ref.refresh()
            ↓
      RIVERPOD PROVIDERS (State)
            ↓
      SERVICES (Business Logic)
            ↓
      API / SharedPreferences / Analytics
```

#### **12. Lessons Learned** (Reflection)

```
## Ce que ce projet m'a Enseigné

**Riverpod** :
- Computed providers > manual state combinations
- Family(id) permet les providers dynamiques
- AsyncValue handling est robuste pour loading states
- ref.refresh() invalide proprement

**E-Commerce** :
- Collections > single favorites flag
- Checkout est complexe mais necessary
- Persistence is critical (panier vidé = utilisateur perdu)

**Architecture** :
- Separating concerns pays off
- Services indépendants = réutilisables
- Testing devient facile avec bonne architecture
```

---

## 🎯 Résumé pour Toi

| Élément | Description |
|---|---|
| **Providers** | 8+ (Products, Cart, Favorites, Filters, Reviews, User, Orders, Analytics) |
| **Screens** | 7-8 (Home, Detail, Cart, Checkout, Confirmation, Favorites, Profile, Search) |
| **Features Bonus** | Collections de favoris + Checkout réaliste + Avis + Analytics |
| **README** | 2000+ mots expliquant chaque provider, architecture, data flows |
| **Temps Estimé** | 40-50 heures (2-3 semaines) |
| **Complexité Riverpod** | Intermédiaire → Avancé (shows real mastery) |

C'est une exo qui sort du lot. 🚀