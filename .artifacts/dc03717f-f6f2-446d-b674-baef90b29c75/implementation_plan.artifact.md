# Mise à jour de la logique d'ajout au panier

L'objectif est de permettre l'incrémentation de la quantité d'un article déjà présent dans le panier au lieu d'ajouter un doublon.

## Changements proposés

### [Data Layer]

#### [MODIFY] [local_storage_service.dart](file:///C:/Users/Desire/Documents/FORMATION/FlutterFire/FLUTTER/shop_hub/lib/data/services/local_storage_service.dart)

- Modifier `addToCart` pour incrémenter la quantité si l'article existe déjà.
- Correction d'un bug dans `updateCartItemQuantity` qui remplaçait tous les articles par l'article mis à jour.

### [Presentation Layer]

#### [MODIFY] [cart_product_state.dart](file:///C:/Users/Desire/Documents/FORMATION/FlutterFire/FLUTTER/shop_hub/lib/presentation/providers/state_providers/cart_product_state.dart)

- (Optionnel) La logique sera principalement gérée dans le service de données, mais on peut s'assurer que le notifier recharge correctement l'état. Actuellement, `addToCart` dans le notifier recharge déjà les items depuis le repository, donc la modification dans `LocalStorageService` devrait suffire.

## Plan de vérification

### Tests Manuels
- Ajouter un article au panier.
- Ajouter le même article une deuxième fois.
- Vérifier dans la page panier que l'article n'apparaît qu'une fois avec une quantité de 2.
- Vérifier que les autres articles du panier ne sont pas affectés (test de non-régression pour le bug corrigé).
