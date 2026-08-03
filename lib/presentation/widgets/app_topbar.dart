import "package:flutter/material.dart";
import "package:shop_hub/core/theme/app_spacing.dart";

class AppTopbar extends StatelessWidget {
  const AppTopbar({
    required this.title,
    this.actions,
    this.subtitle,
    this.subTitleTextStyle,
    this.onPop,
    this.leading,
    this.titleTextStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    ),
    this.spacing = 0,
    this.actionsSpacing = AppSpacing.md,
    this.titleSubtitleSpacing = AppSpacing.xs,
    this.mainAxisAlignment = .spaceBetween,
    this.showLeading = true,
    this.centerTitle = true,
    this.padding = AppSpacing.insetHSm,
    super.key,
  });

  final bool showLeading;
  final bool centerTitle;
  final double spacing;
  final double actionsSpacing;
  final double titleSubtitleSpacing;
  final MainAxisAlignment mainAxisAlignment;
  final VoidCallback? onPop;
  final Widget? leading;
  final List<Widget>? actions;
  final String title;
  final String? subtitle;
  final TextStyle? titleTextStyle;
  final TextStyle? subTitleTextStyle;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding ?? AppSpacing.insetHMd,
      child: Row(
        spacing: !centerTitle && spacing == 0 ? AppSpacing.md : spacing,
        mainAxisAlignment: centerTitle ? mainAxisAlignment : .start,
        children: [
          // LEADING
          if (showLeading)
            leading ?? const BackButton(),
                // IconButton(
                //   onPressed: () =>
                //       context.canPop() ? (onPop ?? context.pop()) : null,
                //   icon: const Icon(
                //     LucideIcons.arrowLeft400,
                //     size: AppSpacing.iconXl,
                //   ),
                //   tooltip: "Retour",
                // ),

          // TITLE
          if (subtitle != null && subtitle!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: titleSubtitleSpacing,
              children: [
                Text(
                  title,
                  style: titleTextStyle ?? theme.appBarTheme.titleTextStyle,
                ),
                Text(subtitle!, style: subTitleTextStyle),
              ],
            )
          else
            Text(title, style: titleTextStyle),

          if (!centerTitle) const Spacer(),

          // ACTIONS
          if (actions?.isNotEmpty == true)
            Row(spacing: actionsSpacing, children: actions!)
          else
            // Visibility( visible: false,child: leading ?? const BackButton()),
            const SizedBox(width: AppSpacing.xl + AppSpacing.xs),
        ],
      ),
    );
  }
}
