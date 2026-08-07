import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hugeicons/hugeicons.dart";
import "package:shop_hub/core/constants/app_keys.dart";
import "package:shop_hub/core/extensions/build_context_extensions.dart";
import "package:shop_hub/core/theme/app_colors.dart";
import "package:shop_hub/core/theme/app_spacing.dart";
import "package:shop_hub/data/models/cart_item.dart";
import "package:shop_hub/data/models/product.dart";

import "../providers/index.dart" show favoriteProductProvider, cartProvider;
import "app_icon_switcher.dart";

class ProductCard extends ConsumerWidget {
  const new({
    super.key,
    required this.product,
    this.onTap,
    this.useHero = false,
  });

  final Product product;
  final bool useHero;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final fullWidth = context.screenWidth;
    final isFavorite =
        ref
            .watch(favoriteProductProvider)
            .value
            ?.favoriteProducts
            .any((p) => p.id == product.id) ??
        false;
    return Card(
      elevation: AppSpacing.elevationMd,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      color: colorScheme.outline.withValues(alpha: .1),
      child: Container(
        height: AppSpacing.yotta * 2.85,
        width: fullWidth * 0.45,
        decoration: const BoxDecoration(borderRadius: AppSpacing.roundedXxl),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: useHero ? "${AppKeys.articleImageHero}"
                        "_${product.title}" : "${product.id}",
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colorScheme.outline,
                        borderRadius: AppSpacing.roundedXxl,
                      ),
                      child: GestureDetector(
                        onTap: onTap,
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
                              // child: HugeIcon(
                              //   icon: HugeIcons.strokeRoundedBabyBoyDress,
                              //   size: AppSpacing.iconXl,
                              //   color: colorScheme.primary,
                              // ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.xs,
                    right: AppSpacing.xs,
                    child: AppIconSwitcher(
                      child: IconButton(
                        alignment: .center,
                        padding: .zero,
                        style: IconButton.styleFrom(
                          backgroundColor: isFavorite
                              ? colorScheme.surface
                              : null,
                          shape: CircleBorder(
                            side: isFavorite
                                ? .none
                                : BorderSide(color: colorScheme.outline),
                          ),
                        ),
                        onPressed: () {
                          ref
                              .read(favoriteProductProvider.notifier)
                              .toggleFavorite(product);
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_outline,
                          size: isFavorite
                              ? AppSpacing.iconLg
                              : AppSpacing.iconXl,
                          color: isFavorite ? AppColors.error : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsetsGeometry.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      product.title,
                      style: textTheme.bodyMedium!.copyWith(fontWeight: .bold),
                      maxLines: 1,
                      overflow: .ellipsis,
                    ),
                    Text(
                      product.description,
                      style: textTheme.labelSmall,
                      overflow: .ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          "\$${product.price}",
                          style: textTheme.titleSmall!.copyWith(
                            fontWeight: .bold,
                          ),
                        ),
                        InkWell(
                          radius: AppSpacing.radiusFull,
                          onTap: () {
                            try {
                              ref
                                  .read(cartProvider.notifier)
                                  .addToCart(
                                CartItem(product: product, quantity: 1),
                              );
                              context.showSnackBar(
                                "Produit ajouté au panier",
                                backgroundColor: AppColors.success,
                              );
                            } catch (e) {
                              context.showSnackBar(
                                "Une erreur s'est produite "
                                    "lors de l'ajout au panier",
                                backgroundColor: AppColors.error,
                              );
                            }
                          },
                          // onTap: () => ref
                          //     .read(cartProvider.notifier)
                          //     .addToCart(
                          //       CartItem(product: product, quantity: 1),
                          //     ),
                          child: const HugeIcon(
                            icon: HugeIcons.strokeRoundedShoppingCart02,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
