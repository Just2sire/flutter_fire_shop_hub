import "package:flutter/material.dart";
import "package:flutter/services.dart" show SystemUiOverlayStyle;
import "package:shop_hub/core/extensions/build_context_extensions.dart";
import "package:shop_hub/core/theme/app_spacing.dart";

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.onPopInvokedWithResult,
    this.canPop = true,
    this.bottomNavigationBar,
    this.body,
    this.padding = AppSpacing.screenPadding,
    this.appBar,
    this.color,
    this.statusBarColor,
    this.bottomSafeArea = true,
    this.extendBody = false,
    this.resizeToAvoidBottomInset = false,
    this.scrollable = false,
    this.scrollReverse = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundBuilder,
    this.onRefresh,
  });

  // ---------------------------------------------------------------------------
  // Navigation / Pop
  // ---------------------------------------------------------------------------

  final void Function(bool, Object?)? onPopInvokedWithResult;
  final bool canPop;

  // ---------------------------------------------------------------------------
  // Layout
  // ---------------------------------------------------------------------------

  final Widget? body;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry padding;
  final PreferredSizeWidget? appBar;
  final Color? color;
  final Color? statusBarColor;
  final bool bottomSafeArea;
  final bool extendBody;
  final bool resizeToAvoidBottomInset;
  final bool scrollable;
  final bool scrollReverse;

  // ---------------------------------------------------------------------------
  // FAB
  // ---------------------------------------------------------------------------

  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  // ---------------------------------------------------------------------------
  // Background
  // ---------------------------------------------------------------------------

  final Widget Function(Widget child)? backgroundBuilder;

  // ---------------------------------------------------------------------------
  // Refresh
  // ---------------------------------------------------------------------------

  /// Wraps scrollable content in a [RefreshIndicator].
  /// Implies [scrollable] — no need to set both.
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = context.isDarkMode;

    // FIX 1 — Status bar contrast.
    // The icons must CONTRAST with the status bar background:
    //   dark background (dark mode)  -> light icons
    //   light background (light mode) -> dark icons
    // `statusBarIconBrightness` drives Android; `statusBarBrightness` drives
    // iOS (with inverted semantics), and was missing before.
    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: statusBarColor ?? theme.scaffoldBackgroundColor,
      statusBarIconBrightness: isDarkMode
          ? Brightness.light
          : Brightness.dark, // Android
      statusBarBrightness: isDarkMode ? .dark : Brightness.light, // iOS
    );

    final isScrollable = scrollable || onRefresh != null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: PopScope(
        canPop: canPop,
        onPopInvokedWithResult: onPopInvokedWithResult,
        child: Scaffold(
          appBar: appBar,
          extendBody: extendBody,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          backgroundColor: color ?? theme.scaffoldBackgroundColor,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,

          // FIX 4 — Let the SafeArea own the system insets, so `bottomSafeArea`
          // actually means what its name says. When `extendBody` is on, we
          // deliberately let content flow behind the bottom bar.
          body: SafeArea(
            bottom: bottomSafeArea && !extendBody,
            child: Builder(
              builder: (context) {
                // FIX 2 — Resolve padding against the REAL text direction so
                // left/right are correct in RTL locales.
                final resolvedPadding = padding.resolve(
                  Directionality.of(context),
                );

                // The SafeArea already handled the system insets, so we only
                // apply the caller's decorative padding here. Behind a bottom
                // bar (extendBody) we drop the bottom padding.
                final effectivePadding = extendBody
                    ? resolvedPadding.copyWith(bottom: 0)
                    : resolvedPadding;

                Widget content;

                if (isScrollable) {
                  // ─── Scrollable ──────────────────────────────────────────
                  // AlwaysScrollablePhysics lets the RefreshIndicator trigger
                  // even when the content is shorter than the viewport.
                  content = SingleChildScrollView(
                    physics: onRefresh != null
                        ? const AlwaysScrollableScrollPhysics()
                        : null,
                    reverse: scrollReverse,
                    child: Padding(
                      // The scroll view already gives full width; no need to
                      // force `size.width`.
                      padding: effectivePadding,
                      child: body,
                    ),
                  );

                  if (onRefresh != null) {
                    content = RefreshIndicator(
                      onRefresh: onRefresh!,
                      child: content,
                    );
                  }
                } else {
                  // ─── Non-scrollable ──────────────────────────────────────
                  // FIX 3 — Fill the space that is ACTUALLY available (the
                  // SafeArea and AppBar have already been removed) instead of
                  // hard-coding the full-screen `size`.
                  content = Container(
                    constraints: const BoxConstraints.expand(),
                    color: color,
                    padding: effectivePadding,
                    child: body,
                  );
                }

                if (backgroundBuilder != null && body != null) {
                  content = backgroundBuilder!(content);
                }

                return content;
              },
            ),
          ),
        ),
      ),
    );
  }
}
