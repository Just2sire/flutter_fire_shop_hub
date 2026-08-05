import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shop_hub/data/repositories/cart_repository_impl.dart";
import "package:shop_hub/presentation/providers/state_providers/cart_product_state.dart";
import "package:shop_hub/presentation/providers/storage_providers.dart";

final cartRepositoryProvider = Provider(
  (ref) => CartRepositoryImpl(
    localStorageService: ref.watch(localStorageServiceProvider),
  ),
);

final cartProvider =
    AsyncNotifierProvider<CartProductNotifier, CartProductState>(
      CartProductNotifier.new,
    );
