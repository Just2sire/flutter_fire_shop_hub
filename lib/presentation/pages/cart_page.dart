import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hugeicons/hugeicons.dart";
import "package:shop_hub/core/constants/notification_channels.dart";
import "package:shop_hub/core/extensions/build_context_extensions.dart";
import "package:shop_hub/core/extensions/navigation_extensions.dart";
import "package:shop_hub/core/theme/app_spacing.dart";
import "package:shop_hub/data/models/cart_item.dart";
import "package:shop_hub/data/models/product.dart";
import "package:shop_hub/presentation/providers/state_providers/cart_product_state.dart";
import "package:shop_hub/presentation/widgets/app_divider.dart";

import "../providers/cart_providers.dart";
import "../providers/notification_providers.dart";
import "../widgets/index.dart"
    show
        AppScaffold,
        Skeleton,
        SkeletonText,
        SkeletonButton,
        AppTopbar,
        AppTextFormField,
        AppElevatedButton;

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final cartRepo = ref.watch(cartProvider);
    return AppScaffold(
      body: Column(
        children: [
          const AppTopbar(title: "Panier"),
          Expanded(
            child: cartRepo.map(
              data: (data) {
                final cartState = data.value;
                final cardProducts = cartState.cartItems;
                return Column(
                  children: [
                    if (cardProducts.isEmpty)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: .center,
                          spacing: AppSpacing.lg,
                          children: [
                            const HugeIcon(
                              icon: HugeIcons.strokeRoundedDeliveryBox01,
                              size: AppSpacing.iconXxl,
                            ),
                            Text(
                              "Votre panier est vide",
                              style: context.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      )
                    else
                      SizedBox(
                        height: context.screenHeight * 0.55,
                        child: ListView.separated(
                          itemBuilder: (_, index) {
                            final cartNotifier = ref.read(
                              cartProvider.notifier,
                            );
                            final cartItem = cardProducts[index];
                            final product = cartItem.product;
                            return _CartProduct(
                              colorScheme: colorScheme,
                              product: product,
                              cartNotifier: cartNotifier,
                              cartItem: cartItem,
                            );
                          },
                          separatorBuilder: (_, _) =>
                              AppDivider(color: colorScheme.outline),
                          itemCount: cardProducts.length,
                        ),
                      ),
                    if (cardProducts.isNotEmpty)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Container(
                              height: AppSpacing.giga * 1 + AppSpacing.xs / 2,
                              padding: const EdgeInsetsGeometry.symmetric(
                                horizontal: AppSpacing.xs / 2,
                                vertical: AppSpacing.xs / 2,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: colorScheme.outline,
                                  width: AppSpacing.elevationSm,
                                ),
                                borderRadius: AppSpacing.roundedFull,
                              ),
                              child: Row(
                                spacing: AppSpacing.sm,
                                children: [
                                  Expanded(
                                    child: AppTextFormField(
                                      // height: AppSpacing.giga * 0.95,
                                      filled: true,
                                      fillColor: colorScheme.surface,
                                      hintText: "Code coupon...",
                                      textInputAction: TextInputAction.search,
                                      onChanged: (query) {},
                                      border: const OutlineInputBorder(
                                        borderRadius: AppSpacing.roundedFull,
                                        borderSide: .none,
                                      ),
                                    ),
                                  ),
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                      fixedSize: Size(
                                        context.screenWidth * 0.3,
                                        AppSpacing.giga * 1.1,
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const Text("Appliquer"),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: AppSpacing.insetHSm,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: .spaceBetween,
                                    children: [
                                      Text(
                                        "Somme:",
                                        style: textTheme.bodySmall,
                                      ),
                                      Text(
                                        "\$${cartState.totalPrice}",
                                        style: textTheme.titleMedium!.copyWith(
                                          fontWeight: .bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: .spaceBetween,
                                    children: [
                                      Text(
                                        "Remise:",
                                        style: textTheme.bodySmall,
                                      ),
                                      Text(
                                        "\$${cartState.discountAmount}",
                                        style: textTheme.titleMedium!.copyWith(
                                          fontWeight: .bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: .spaceBetween,
                                    children: [
                                      Text(
                                        "Livraison:",
                                        style: textTheme.bodySmall,
                                      ),
                                      Text(
                                        "\$${cartState.shippingPrice}",
                                        style: textTheme.titleMedium!.copyWith(
                                          fontWeight: .bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: .spaceBetween,
                                    children: [
                                      Text(
                                        "Total:",
                                        style: textTheme.bodySmall,
                                      ),
                                      Text(
                                        "\$${cartState.finalPrice}",
                                        style: textTheme.titleMedium!.copyWith(
                                          fontWeight: .bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            AppElevatedButton(
                              onPressed: () {
                                context.showSnackBar("Paiement non implémenté");
                                ref.read(notificationServiceProvider).show(id: NotificationId.checkout, title: "Achat sur ShopHub", body: "Désolé nous n'avons pas pu gérer votre paiement");
                              },
                              text: "Procéder au paiement",
                              margin: .zero,
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
              error: (err) => Center(child: Text(err.error.toString())),
              loading: (_) => const _CartSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartProduct extends StatelessWidget {
  const new({
    required this.colorScheme,
    required this.product,
    required this.cartNotifier,
    required this.cartItem,
  });

  final ColorScheme colorScheme;
  final Product product;
  final CartProductNotifier cartNotifier;
  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.md,
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: AppSpacing.yotta * 1.375,
            child: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.outline,
                    borderRadius: AppSpacing.roundedXxl,
                  ),
                  child: GestureDetector(
                    onTap: () => context.pushToProductDetail("${product.id}"),
                    child: Image.network(
                      product.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return ColoredBox(
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            size: AppSpacing.iconXl,
                            color: colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: AppSpacing.xs,
                  left: AppSpacing.xs,
                  child: IconButton(
                    alignment: .center,
                    padding: .zero,
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.surface.withValues(
                        alpha: 0.4,
                      ),
                    ),
                    onPressed: () {
                      cartNotifier.removeFromCart(cartItem);
                    },
                    icon: Icon(
                      Icons.close,
                      size: AppSpacing.iconMd,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: _CheckoutSection(
            product: product,
            colorScheme: colorScheme,
            cartItem: cartItem,
            cartNotifier: cartNotifier,
          ),
        ),
      ],
    );
  }
}

class _CheckoutSection extends StatelessWidget {
  const new({
    required this.product,
    required this.colorScheme,
    required this.cartItem,
    required this.cartNotifier,
  });

  final Product product;
  final ColorScheme colorScheme;
  final CartItem cartItem;
  final CartProductNotifier cartNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.sm,
      crossAxisAlignment: .start,
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          product.title,
          style: context.textTheme.titleLarge!.copyWith(fontWeight: .bold),
          maxLines: 1,
          overflow: .ellipsis,
        ),
        Text(
          product.description,
          style: context.textTheme.labelMedium,
          maxLines: 2,
          overflow: .ellipsis,
        ),
        Row(
          children: [
            Text("\$${product.price}", style: context.textTheme.titleSmall),
            const Spacer(),
            Container(
              padding: const EdgeInsetsGeometry.symmetric(
                horizontal: AppSpacing.md / 2,
                vertical: AppSpacing.xs / 2,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: AppSpacing.roundedFull,
              ),
              child: Row(
                spacing: AppSpacing.sm,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (cartItem.quantity > 1) {
                        cartNotifier.updateCart(
                          cartItem.copyWith(quantity: cartItem.quantity - 1),
                        );
                      }
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: AppSpacing.roundedFull,
                      ),
                      child: const Icon(Icons.remove, size: AppSpacing.iconMd),
                    ),
                  ),
                  Text(cartItem.quantity.toString()),
                  GestureDetector(
                    onTap: () => cartNotifier.updateCart(
                      cartItem.copyWith(quantity: cartItem.quantity + 1),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: AppSpacing.roundedFull,
                      ),
                      child: const Icon(Icons.add, size: AppSpacing.iconMd),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CartSkeleton extends StatelessWidget {
  const _CartSkeleton();

  @override
  Widget build(BuildContext context) {
    final fullWidth = context.screenWidth;
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: AppSpacing.md),
      child: Column(
        spacing: AppSpacing.xl,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              spacing: AppSpacing.md,
              children: List.generate(
                3,
                (index) => Row(
                  spacing: AppSpacing.md,
                  crossAxisAlignment: .start,
                  children: [
                    Skeleton(
                      height: AppSpacing.yotta * 1.25,
                      width: fullWidth * 0.4,
                    ),
                    Column(
                      spacing: AppSpacing.sm,
                      children: List.generate(
                        3,
                        (index) => Skeleton(
                          height: AppSpacing.lg,
                          width: fullWidth * 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Column(
              spacing: AppSpacing.md,
              crossAxisAlignment: .start,
              children: [
                Row(
                  spacing: AppSpacing.md,
                  children: [
                    Expanded(child: Skeleton(height: AppSpacing.giga)),
                    Skeleton(
                      height: AppSpacing.giga,
                      width: AppSpacing.yotta * 1.5,
                      borderRadius: AppSpacing.roundedFull,
                    ),
                  ],
                ),
                SkeletonText(lineHeight: 20),
                Spacer(),
                SkeletonButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
