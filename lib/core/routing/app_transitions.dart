import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../theme/app_spacing.dart";

/// Centralized class for application route transitions.
class AppTransitions {
  AppTransitions._();

  // ─────────────────────────────────────────────
  // PUBLIC TRANSITIONS
  // ─────────────────────────────────────────────

  /// Fade simple — idéal pour les changements d'onglet ou la splash.
  static CustomTransitionPage<T> fade<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = AppSpacing.durationBase,
    Duration? reverseDuration,
    Curve curve = AppSpacing.curveDefault,
  }) {
    return _page(
      state: state,
      child: child,
      duration: duration,
      reverseDuration: reverseDuration,
      builder: (context, animation, _, child) =>
          FadeTransition(opacity: _curved(animation, curve), child: child),
    );
  }

  /// Slide depuis une direction — idéal pour la navigation forward/back.
  ///
  /// [begin] contrôle la direction : `(1, 0)` = droite (défaut),
  /// `(-1, 0)` = gauche, `(0, 1)` = bas, `(0, -1)` = haut.
  static CustomTransitionPage<T> slide<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Offset begin = const Offset(1.0, 0.0),
    Duration duration = AppSpacing.durationBase,
    Duration? reverseDuration,
    Curve curve = AppSpacing.curveEnter,
  }) {
    return _page(
      state: state,
      child: child,
      duration: duration,
      reverseDuration: reverseDuration,
      builder: (context, animation, _, child) => SlideTransition(
        position: Tween<Offset>(
          begin: begin,
          end: Offset.zero,
        ).animate(_curved(animation, curve)),
        child: child,
      ),
    );
  }

  /// Fade + glissement vertical subtil — la transition la plus naturelle
  /// pour les pages de contenu.
  ///
  /// [begin] est intentionnellement petit (`0.04`) pour un effet discret.
  static CustomTransitionPage<T> fadeSlide<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Offset begin = const Offset(0.0, 0.04),
    Duration duration = AppSpacing.durationBase,
    Duration? reverseDuration,
    Curve curve = AppSpacing.curveEnter,
  }) {
    return _page(
      state: state,
      child: child,
      duration: duration,
      reverseDuration: reverseDuration,
      builder: (context, animation, _, child) {
        final curved = _curved(animation, curve);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: begin,
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Fade + scale — idéal pour les modals et les pages de détail.
  ///
  /// [beginScale] à `0.92` donne un effet d'ouverture naturel sans être trop
  /// dramatique.
  static CustomTransitionPage<T> fadeScale<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    double beginScale = 0.92,
    Duration duration = AppSpacing.durationBase,
    Duration? reverseDuration,
    Curve curve = AppSpacing.curveEnter,
  }) {
    return _page(
      state: state,
      child: child,
      duration: duration,
      reverseDuration: reverseDuration,
      builder: (context, animation, _, child) {
        final curved = _curved(animation, curve);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: beginScale, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Scale seul — bon pour les popups et les overlays.
  ///
  /// Commence à [beginScale] (`0.85` par défaut) pour rester lisible.
  static CustomTransitionPage<T> scale<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    double beginScale = 0.85,
    Duration duration = AppSpacing.durationBase,
    Duration? reverseDuration,
    Curve curve = AppSpacing.curveEnter,
  }) {
    return _page(
      state: state,
      child: child,
      duration: duration,
      reverseDuration: reverseDuration,
      builder: (context, animation, _, child) => ScaleTransition(
        scale: Tween<double>(
          begin: beginScale,
          end: 1.0,
        ).animate(_curved(animation, curve)),
        child: child,
      ),
    );
  }

  /// Aucune transition — affichage instantané.
  ///
  /// Utile pour la route initiale ou les redirections programmatiques.
  static CustomTransitionPage<T> none<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return _page(
      state: state,
      child: child,
      duration: Duration.zero,
      builder: (context, _, _, child) => child,
    );
  }

  // ─────────────────────────────────────────────
  // PRIVATE HELPERS
  // ─────────────────────────────────────────────

  static CustomTransitionPage<T> _page<T>({
    required GoRouterState state,
    required Widget child,
    required Widget Function(
        BuildContext,
        Animation<double>,
        Animation<double>,
        Widget,
        )
    builder,
    required Duration duration,
    Duration? reverseDuration,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration ?? duration,
      transitionsBuilder: builder,
    );
  }

  static Animation<double> _curved(Animation<double> animation, Curve curve) =>
      CurvedAnimation(parent: animation, curve: curve);
}
