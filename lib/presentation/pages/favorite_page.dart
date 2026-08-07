import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hugeicons/hugeicons.dart";
import "package:shop_hub/core/extensions/build_context_extensions.dart";
import "package:shop_hub/core/extensions/navigation_extensions.dart";
import "package:shop_hub/core/theme/app_colors.dart";
import "package:shop_hub/core/theme/app_spacing.dart";
import "package:shop_hub/data/models/index.dart";
import "package:shop_hub/presentation/providers/cart_providers.dart";
import "package:shop_hub/presentation/providers/favorite_providers.dart";
import "package:shop_hub/presentation/widgets/app_divider.dart";
import "package:shop_hub/presentation/widgets/app_elevated_button.dart";
import "package:shop_hub/presentation/widgets/app_scaffold.dart";
import "package:shop_hub/presentation/widgets/app_topbar.dart";
import "package:shop_hub/presentation/widgets/skeleton.dart";

import "../providers/app_page_provider.dart";

class FavoritePage extends ConsumerWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final favoriteState = ref.watch(favoriteProductProvider);

    return AppScaffold(
      body: Column(
        children: [
          const AppTopbar(title: "Favoris"),
          Expanded(
            child: favoriteState.map(
              data: (data) {
                final favoriteProducts =
                    data.value.favoriteProducts.toSet().toList();
                if (favoriteProducts.isEmpty) {
                  return const _EmptyFavoritesView();
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                  ),
                  itemCount: favoriteProducts.length,
                  separatorBuilder: (_, _) =>
                      AppDivider(color: colorScheme.outline),
                  itemBuilder: (context, index) {
                    return _FavoriteItemRow(product: favoriteProducts[index]);
                  },
                );
              },
              error: (err) => Center(child: Text(err.error.toString())),
              loading: (_) => const _FavoriteSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteItemRow extends ConsumerWidget {
  const _FavoriteItemRow({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final favoriteNotifier = ref.read(favoriteProductProvider.notifier);
    final cartNotifier = ref.read(cartProvider.notifier);

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
                    alignment: Alignment.center,
                    padding: EdgeInsets.zero,
                    style: IconButton.styleFrom(
                      backgroundColor:
                          colorScheme.surface.withValues(alpha: 0.6),
                    ),
                    onPressed: () {
                      favoriteNotifier.removeFromFavorite(product);
                      context.showSnackBar(
                        "Article retiré des favoris",
                      );
                    },
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedFavourite,
                      size: AppSpacing.iconMd,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            spacing: AppSpacing.sm,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.title,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                product.description,
                style: textTheme.labelMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price}",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppSpacing.roundedFull,
                      ),
                    ),
                    onPressed: () {
                      try {
                        cartNotifier.addToCart(
                          CartItem(product: product, quantity: 1),
                        );
                        context.showSnackBar(
                          "Produit ajouté au panier",
                          backgroundColor: AppColors.success,
                        );
                      } catch (e) {
                        context.showSnackBar(
                          "Une erreur s'est produite lors de l'ajout",
                          backgroundColor: AppColors.error,
                        );
                      }
                    },
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedShoppingBag01,
                      size: AppSpacing.iconSm,
                    ),
                    label: const Text("Ajouter"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyFavoritesView extends ConsumerWidget {
  const _EmptyFavoritesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = context.textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppSpacing.lg,
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedFavourite,
            size: AppSpacing.iconXxxl,
          ),
          Text(
            "Votre liste de favoris est vide",
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Explorez nos produits et ajoutez vos articles préférés !",
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapVMd,
          AppElevatedButton(
            onPressed: () {
              context.goToHome();
              ref.read(appPageProvider.notifier).state = 0;
            },
            text: "Découvrir les produits",
          ),
        ],
      ),
    );
  }
}

class _FavoriteSkeleton extends StatelessWidget {
  const _FavoriteSkeleton();

  @override
  Widget build(BuildContext context) {
    final fullWidth = context.screenWidth;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        spacing: AppSpacing.xl,
        children: [
          Expanded(
            child: Column(
              spacing: AppSpacing.md,
              children: List.generate(
                3,
                (index) => Row(
                  spacing: AppSpacing.md,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
        ],
      ),
    );
  }
}
