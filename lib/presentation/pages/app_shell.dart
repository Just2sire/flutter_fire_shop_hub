// ignore_for_file: unused_element_parameter

import "dart:ui" show ImageFilter;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:hugeicons/hugeicons.dart";
import "package:shop_hub/core/extensions/build_context_extensions.dart";
import "package:shop_hub/core/theme/app_colors.dart";
import "package:shop_hub/core/theme/app_spacing.dart";
import "package:shop_hub/presentation/providers/app_page_provider.dart";
import "package:shop_hub/presentation/widgets/app_scaffold.dart";

class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(appPageProvider);
    final navItems = ref.watch(appNavItemsProvider);

    return AppScaffold(
      padding: EdgeInsets.zero,
      extendBody: true,
      bottomSafeArea: false,
      body: Builder(
        builder: (context) {
          if (context.isMobile) return navigationShell;
          return Row(
            children: [
              NavigationRail(
                selectedIndex: currentPage,
                onDestinationSelected: (index) => changePage(ref, index),
                labelType: NavigationRailLabelType.selected,
                destinations: List.generate(navItems.length, (index) {
                  final item = navItems[index];
                  return NavigationRailDestination(
                    icon: HugeIcon(icon: item.icon),
                    label: Text(item.label),
                  );
                }),
              ),
              VerticalDivider(
                thickness: 1,
                width: 1,
                color: context.colorScheme.outline,
              ),
              Expanded(child: navigationShell),
            ],
          );
        },
      ),
      bottomNavigationBar: _BottomNavBar(
        navItems: navItems,
        currentIndex: currentPage,
        onTap: (index) => changePage(ref, index),
      ),
    );
  }

  void changePage(WidgetRef ref, int value) {
    ref.read(appPageProvider.notifier).state = value;
    navigationShell.goBranch(
      value,
      // initialLocation: value == navigationShell.currentIndex,
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.navItems,
    required this.currentIndex,
    this.onTap,
    this.labelStyle,
  });

  final int currentIndex;
  final void Function(int)? onTap;
  final List<_NavItemData> navItems;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: AppSpacing.insetMd,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: AppSpacing.roundedFull,
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppSpacing.roundedFull,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppSpacing.sm,
            sigmaY: AppSpacing.sm,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.2),
              borderRadius: AppSpacing.roundedFull,
              border: Border.all(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: navItems.map((item) {
                  final isSelected = currentIndex == item.index;
                  return _BottomNavItem(
                    icon: HugeIcon(
                      icon: item.icon,
                      color: isSelected ? context.colorScheme.surface : null,
                    ),
                    label: item.label,
                    index: item.index,
                    isSelected: isSelected,
                    labelStyle: labelStyle,
                    onSelection: () => onTap?.call(item.index),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.index,
    this.isSelected = false,
    this.onSelection,
    this.labelStyle,
  });

  final Widget icon;
  final String? label;
  final int index;
  final bool? isSelected;
  final TextStyle? labelStyle;
  final void Function()? onSelection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onSelection,
      child: AnimatedContainer(
        duration: AppSpacing.durationBase,
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected! ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected!
              ? theme
                    .colorScheme
                    .onSurface //.withValues(alpha: 0.8)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            icon,
            if (isSelected! && label != null && label!.isNotEmpty) ...[
              AppSpacing.gapHMd,
              Text(
                label!,
                style:
                    labelStyle ??
                    theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.surface,
                      fontWeight: .w600,
                      fontSize: 16,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

typedef _NavItemData = ({
  int index,
  List<List<dynamic>> icon,
  String label,
  String route,
});
