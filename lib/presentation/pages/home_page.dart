// ignore_for_file: unused_element_parameter

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hugeicons/hugeicons.dart";
import "package:shop_hub/core/constants/app_assets.dart";
import "package:shop_hub/core/extensions/build_context_extensions.dart";
import "package:shop_hub/core/extensions/navigation_extensions.dart";
import "package:shop_hub/core/theme/app_spacing.dart";
import "package:shop_hub/data/models/index.dart";
import "package:shop_hub/presentation/providers/product_providers.dart";
import "package:shop_hub/presentation/providers/selected_category_provider.dart";

import "../providers/user_providers.dart";
import "../widgets/index.dart"
    show AppScaffold, AppTextFormField, Skeleton, ProductCard;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final fullWidth = context.screenWidth;
    // PROVIDERS
    final categoriesRepo = ref.watch(productCategoriesProvider);
    final productRepo = ref.watch(productListProvider);
    final userAsync = ref.watch(userProvider);
    final user = userAsync.value;

    return AppScaffold(
      scrollable: true,
      resizeToAvoidBottomInset: true,
      body: Column(
        spacing: AppSpacing.md,
        crossAxisAlignment: .start,
        children: [
          _AppTopbar(colorScheme: colorScheme, user: user),
          SizedBox(
            width: context.screenWidth * .8,
            child: Text(
              "Découvrez des articles à des prix imbattables",
              style: textTheme.headlineSmall!.copyWith(
                fontWeight: .bold,
                overflow: .ellipsis,
              ),
              maxLines: 2,
              textAlign: .start,
            ),
          ),
          const AppTextFormField(
            border: OutlineInputBorder(
              borderRadius: AppSpacing.roundedFull,
              borderSide: .none,
            ),
            filled: true,
            prefixIcon: Icon(Icons.search_outlined, size: AppSpacing.iconMxl),
            hintText: "Recherche...",
          ),
          Card(
            margin: .zero,
            child: Container(
              height: AppSpacing.yotta * 1.5,
              padding: AppSpacing.cardPaddingUltraCompact,
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: .spaceEvenly,
                      crossAxisAlignment: .start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Obtener jusqu'à ",
                            style: textTheme.titleMedium!.copyWith(
                              fontWeight: .normal,
                            ),
                            children: const [
                              TextSpan(
                                text: "20%",
                                style: TextStyle(fontWeight: .bold),
                              ),
                              TextSpan(text: " de réduction sur tout achat"),
                            ],
                          ),
                        ),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.surface,
                            iconAlignment: .end,
                          ),
                          onPressed: () {},
                          label: Text(
                            "Profiter maintenant",
                            style: textTheme.bodyMedium!.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowRight02,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Image.asset(AppAssets.chair, height: 200),
                  ),
                ],
              ),
            ),
          ),
          categoriesRepo.map(
            data: (data) {
              final categories = data.value;
              return SizedBox(
                height: AppSpacing.mega,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: .horizontal,
                  itemCount: categories.length > 8 ? 8 : categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        ref.read(selectedCategoryProvider.notifier).state =
                            category.slug;
                        context.goToProducts();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.md),
                        child: Chip(
                          avatar: CircleAvatar(
                            child: Text(
                              category.name[0],
                              style: textTheme.labelLarge!.copyWith(
                                color: colorScheme.surface,
                                fontWeight: .bold,
                              ),
                            ),
                          ),
                          label: Text(
                            category.name,
                            style: textTheme.bodySmall,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            error: (res) => Center(child: Text(res.error.toString())),
            loading: (_) => _SectionSkeleton(
              length: 4,
              child: Skeleton(
                width: (fullWidth - (2 * AppSpacing.md)) * 0.225,
                height: 30,
                borderRadius: AppSpacing.roundedXxxl,
              ),
            ),
          ),
          productRepo.map(
            data: (data) {
              final products = data.value.products;
              return SizedBox(
                height: AppSpacing.yotta * 2.85,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: .horizontal,
                  itemCount: products.length > 4 ? 4 : products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return ProductCard(
                      product: product,
                      onTap: () => context.pushToProductDetail("${product.id}"),
                    );
                  },
                ),
              );
            },
            error: (res) => Center(child: Text(res.error.toString())),
            loading: (_) => _SectionSkeleton(
              length: 2,
              child: Column(
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppTopbar extends StatelessWidget {
  const new({required this.colorScheme, this.user});

  final ColorScheme colorScheme;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.sm,
      children: [
        CircleAvatar(
          backgroundColor: colorScheme.secondary,
          radius: AppSpacing.xxl,
          backgroundImage: const AssetImage(AppAssets.userIcon),
        ),
        RichText(
          text: TextSpan(
            text: "Salut 👋\n",
            style: context.textTheme.bodyLarge!.copyWith(
              fontWeight: .w500,
            ),
            children: [
              TextSpan(
                text: user?.username ?? "Aholou",
                style: context.textTheme.titleLarge!.copyWith(
                  fontWeight: .bold
                ),
              ),
            ],
          ),
        ),
        // Column(
        //   crossAxisAlignment: .start,
        //   children: [
        //     Text("Salut 👋", style: context.textTheme.bodyMedium),
        //     Text(
        //       user?.username ?? "Aholou",
        //       style: context.textTheme.titleMedium,
        //     ),
        //   ],
        // ),
        const Spacer(),
        IconButton(
          style: IconButton.styleFrom(
            padding: AppSpacing.insetMd,
            backgroundColor: colorScheme.secondary.withValues(alpha: 0.1),
          ),
          onPressed: () => context.pushToCart(),
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedShoppingBag03,
            size: AppSpacing.iconMxl,
          ),
          tooltip: "Panier",
        ),
        IconButton(
          style: IconButton.styleFrom(
            padding: AppSpacing.insetMd,
            backgroundColor: colorScheme.secondary.withValues(alpha: 0.1),
          ),
          onPressed: () {},
          icon: const Badge(
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedNotification01,
              size: AppSpacing.iconMxl,
            ),
          ),
          tooltip: "Notifications",
        ),
      ],
    );
  }
}

class _SectionSkeleton extends StatelessWidget {
  const _SectionSkeleton({
    this.child,
    this.length = 3,
    this.scrollable = false,
    this.showTitle = false,
    this.scrollAreaHeight = AppSpacing.zetta * 2.25,
  });

  final Widget? child;
  final int length;
  final bool scrollable;
  final bool showTitle;
  final double scrollAreaHeight;

  @override
  Widget build(BuildContext context) {
    final fullWidth = context.screenWidth;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: fullWidth),
      child: Column(
        spacing: AppSpacing.sm,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle) Skeleton(width: fullWidth * 0.9, height: 16),
          if (scrollable)
            SizedBox(
              height: scrollAreaHeight,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: .horizontal,
                children: List.generate(
                  length,
                  (index) =>
                      child ??
                      Skeleton(
                        width: (fullWidth - (2 * AppSpacing.md)) * 0.3,
                        height: 120,
                        borderRadius: AppSpacing.roundedMd,
                      ),
                ),
              ),
            )
          else
            Row(
              mainAxisAlignment: .spaceBetween,
              spacing: AppSpacing.md,
              children: List.generate(
                length,
                (index) =>
                    child ??
                    Skeleton(
                      width: (fullWidth - (2 * AppSpacing.md)) * length / 10,
                      height: 120,
                      borderRadius: AppSpacing.roundedMd,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
