import "package:flutter/material.dart";
import "package:hugeicons/hugeicons.dart";
import "package:shop_hub/core/constants/app_assets.dart";
import "package:shop_hub/core/extensions/build_context_extensions.dart";
import "package:shop_hub/core/theme/app_spacing.dart";
import "package:shop_hub/presentation/widgets/index.dart" show AppScaffold;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    return AppScaffold(
      body: Column(
        spacing: AppSpacing.md,
        crossAxisAlignment: .start,
        children: [
          _AppTopbar(colorScheme: colorScheme),
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
          // AppTopbar(title: "title"),
          const Center(child: Text("HOME")),
        ],
      ),
    );
  }
}

class _AppTopbar extends StatelessWidget {
  const new({required this.colorScheme});

  final ColorScheme colorScheme;

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
        const Spacer(),
        IconButton(
          style: IconButton.styleFrom(
            padding: AppSpacing.insetMd,
            backgroundColor: colorScheme.secondary.withValues(alpha: 0.1),
          ),
          onPressed: () {},
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
