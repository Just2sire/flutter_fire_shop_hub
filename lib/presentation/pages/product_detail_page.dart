import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shop_hub/core/constants/app_keys.dart";
import "package:shop_hub/core/extensions/build_context_extensions.dart";
import "package:shop_hub/core/theme/app_colors.dart";
import "package:shop_hub/core/theme/app_spacing.dart";
import "package:shop_hub/data/models/cart_item.dart";

import "../providers/cart_providers.dart";
import "../providers/favorite_providers.dart";
import "../providers/product_providers.dart";
import "../widgets/index.dart"
    show
        AppScaffold,
        AppTopbar,
        Skeleton,
        SkeletonText,
        SkeletonTile,
        AppIconSwitcher,
        AppElevatedButton;

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final asyncProduct = ref.watch(productDetailProvider(productId));
    return AppScaffold(
      body: asyncProduct.map(
        data: (data) {
          final product = data.value;
          final isFavorite =
              ref
                  .watch(favoriteProductProvider)
                  .value
                  ?.favoriteProducts
                  .any((p) => p.id == product.id) ??
              false;
          return Column(
            spacing: AppSpacing.md,
            children: [
              const AppTopbar(title: "Détails de produit"),
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag:
                          "${AppKeys.articleImageHero}"
                          "_${product.title}",
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colorScheme.outline,
                          borderRadius: AppSpacing.roundedXxl,
                        ),
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
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_outline,
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
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      crossAxisAlignment: .start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                product.title,
                                style: textTheme.headlineMedium!.copyWith(
                                  fontWeight: .w500,
                                ),
                                maxLines: 2,
                              ),
                              Text(
                                product.description,
                                style: textTheme.labelLarge!.copyWith(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "\$${product.price}",
                          style: textTheme.headlineLarge!.copyWith(
                            fontWeight: .bold,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapVSm,
                    Wrap(
                      spacing: AppSpacing.xs / 4,
                      children: [
                        ...List.generate(5, (index) {
                          final isColored = index < product.rating.toInt();
                          return Icon(
                            isColored ? Icons.star : Icons.star_border,
                            color: isColored
                                ? Colors.amber
                                : colorScheme.outline,
                          );
                        }),
                        AppSpacing.gapHSm,
                        Text(
                          "${product.rating}/5 (120 revues)",
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const Spacer(),
                    AppElevatedButton(
                      margin: .zero,
                      onPressed: () {
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
                      text: "Ajouter au panier",
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        error: (err) => Center(child: Text(err.error.toString())),
        loading: (_) => const _DetailSkeleton(),
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: AppSpacing.md),
      child: Column(
        spacing: AppSpacing.xl,
        children: [
          SkeletonTile(),
          Expanded(flex: 3, child: Skeleton()),
          Expanded(
            flex: 2,
            child: Column(
              spacing: AppSpacing.md,
              crossAxisAlignment: .start,
              children: [
                Row(
                  spacing: AppSpacing.md,
                  children: [
                    Expanded(child: Skeleton(height: AppSpacing.giga)),
                    Skeleton(height: AppSpacing.giga, width: AppSpacing.giga),
                  ],
                ),
                SkeletonText(lines: 5, lineHeight: 20, spacing: 6),
                // const SizedBox(height: AppSpacing.sm),
                // // Subtitle / metadata row
                // const Row(
                //   children: [
                //     Skeleton(width: 80, height: 10),
                //     SizedBox(width: AppSpacing.md),
                //     Skeleton(width: 60, height: 10),
                //   ],
                // ),
              ],
            ),
          ),
          // SkeletonCard(),
          // Skeleton(
          //   width: (fullWidth - (2 * AppSpacing.md)) * 0.475,
          //   height: AppSpacing.yotta * 2,
          //   borderRadius: AppSpacing.roundedXxxl,
          // ),
        ],
      ),
    );
  }
}
