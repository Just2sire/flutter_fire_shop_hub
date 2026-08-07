import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hugeicons/hugeicons.dart";
import "package:shop_hub/core/extensions/build_context_extensions.dart";
import "package:shop_hub/core/extensions/navigation_extensions.dart";
import "package:shop_hub/core/theme/app_spacing.dart";
import "package:shop_hub/data/models/index.dart";
import "package:shop_hub/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar, AppTextFormField, Skeleton, ProductCard;

import "../providers/product_providers.dart";

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  late TextEditingController _searchController;
  ProductFilter _productFilter = const ProductFilter();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isMobile = context.isMobile;
    final productsRepo = ref.watch(productListProvider);
    return AppScaffold(
      body: Column(
        spacing: AppSpacing.md,
        children: [
          AppTopbar(
            title: "Nos produits",
            showLeading: false,
            actions: [
              IconButton(
                style: IconButton.styleFrom(
                  padding: AppSpacing.insetMd,
                  // backgroundColor: colorScheme
                  // .secondary.withValues(alpha: 0.1),
                ),
                onPressed: () => context.pushToCart(),
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedShoppingBag03,
                  size: AppSpacing.iconMxl,
                ),
                tooltip: "Panier",
              ),
            ],
          ),
          Row(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: AppTextFormField(
                  contentPadding: AppSpacing.inputPaddingSm,
                  controller: _searchController,
                  hintText: "Recherche par titre, desc...",
                  textInputAction: TextInputAction.search,
                  onChanged: (query) {},
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search_outlined,
                        size: AppSpacing.iconLg,
                      ),
                    ),
                  ),
                ),
              ),
              Badge(
                textColor: colorScheme.tertiary,
                child: IconButton(
                  style: IconButton.styleFrom(
                    padding: AppSpacing.insetLg,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppSpacing.roundedLg,
                    ),
                    backgroundColor: _productFilter.hasActiveFilter
                        ? colorScheme.primary
                        : colorScheme.primaryContainer,
                  ),
                  onPressed: () {},
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedFilterMail,
                    color: _productFilter.hasActiveFilter
                        ? colorScheme.onPrimary
                        : colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: productsRepo.map(
              data: (data) {
                final products = data.value.products;
                return GridView.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 2 : 3,
                    childAspectRatio: 0.725,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.sm,
                  ),
                  itemBuilder: (_, index) {
                    final product = products[index];
                    return ProductCard(
                      useHero: true,
                      product: product,
                      onTap: () => context.pushToProductDetail("${product.id}"),
                    );
                  },
                );
              },
              error: (err) => Center(child: Text(err.error.toString())),
              loading: (_) => const _ProductsSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsSkeleton extends StatelessWidget {
  const _ProductsSkeleton();

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final fullWidth = context.screenWidth;
    return GridView.builder(
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 3,
        childAspectRatio: 0.725,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.xs,
      ),
      itemBuilder: (context, index) {
        return Column(
          spacing: AppSpacing.md,
          children: [
            Skeleton(
              width: (fullWidth - (2 * AppSpacing.md)) * 0.475,
              height: AppSpacing.yotta * 2,
              borderRadius: AppSpacing.roundedXxxl,
            ),
            Skeleton(
              width: (fullWidth - (2 * AppSpacing.md)) * 0.475,
              height: AppSpacing.xxxl,
              borderRadius: AppSpacing.roundedXxxl,
            ),
          ],
        );
      },
    );
  }
}
