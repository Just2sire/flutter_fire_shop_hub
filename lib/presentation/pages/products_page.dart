import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hugeicons/hugeicons.dart";
import "package:shop_hub/core/extensions/build_context_extensions.dart";
import "package:shop_hub/core/extensions/navigation_extensions.dart";
import "package:shop_hub/core/theme/app_spacing.dart";
import "package:shop_hub/data/models/index.dart";
import "package:shop_hub/presentation/widgets/index.dart"
    show
        AppOutlinedButton,
        AppScaffold,
        AppTextFormField,
        AppTopbar,
        FiltersBottomSheet,
        ProductCard,
        Skeleton;

import "../providers/product_providers.dart";
import "../providers/selected_category_provider.dart";

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

    // Filtrer par catégorie si une catégorie a été sélectionnée depuis la home
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categorySlug = ref.read(selectedCategoryProvider);
      if (categorySlug != null) {
        setState(() {
          _productFilter = _productFilter.copyWith(category: categorySlug);
        });
        ref.read(selectedCategoryProvider.notifier).state = null;
        unawaited(
          ref.read(productListProvider.notifier).filterByCategory(
            categorySlug,
            _productFilter,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String? query) {
    final value = query ?? "";
    setState(() {
      _productFilter = _productFilter.copyWith(
        searchQuery: value.isEmpty ? null : value,
      );
    });
    unawaited(
      ref.read(productListProvider.notifier).filterProducts(_productFilter),
    );
  }

  Future<void> _openFilterBottomSheet() async {
    final categories = ref.read(productCategoriesProvider).value ?? [];
    final result = await showModalBottomSheet<ProductFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
        useRootNavigator: true,
      builder: (context) => FiltersBottomSheet(
        initialFilter: _productFilter,
        availableCategories: categories,
      ),
    );

    if (result != null) {
      setState(() {
        _productFilter = result;
        if (result.searchQuery != null) {
          _searchController.text = result.searchQuery!;
        }
      });
      unawaited(ref.read(productListProvider.notifier).filterProducts(result));
    }
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _productFilter = const ProductFilter();
    });
    unawaited(
      ref
          .read(productListProvider.notifier)
          .filterProducts(const ProductFilter()),
    );
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
                  onChanged: _onSearchChanged,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: IconButton(
                      onPressed: () => _onSearchChanged(_searchController.text),
                      icon: const Icon(
                        Icons.search_outlined,
                        size: AppSpacing.iconLg,
                      ),
                    ),
                  ),
                ),
              ),
              Badge(
                isLabelVisible: _productFilter.hasActiveFilter,
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
                  onPressed: _openFilterBottomSheet,
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
                final products = data.value.filteredProducts;

                if (products.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedSearch01,
                            size: AppSpacing.iconXxxl,
                            color: colorScheme.outline,
                          ),
                          AppSpacing.gapVMd,
                          Text(
                            "Aucun produit ne correspond à vos filtres.",
                            style: textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          AppSpacing.gapVSm,
                          AppOutlinedButton(
                            onPressed: _resetFilters,
                            text: "Réinitialiser les filtres",
                          ),
                        ],
                      ),
                    ),
                  );
                }

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
