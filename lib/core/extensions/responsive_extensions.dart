import "package:flutter/material.dart";
import "build_context_extensions.dart";

/// Extension pour le responsive design
extension ResponsiveExtensions on BuildContext {
  /// Dimension adaptée au device
  /// Retourne une valeur différente selon le type d'appareil
  double responsiveSize({
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    final width = MediaQuery.of(this).size.width;
    if (width < 600) {
      return mobile;
    }
    if (width < 1200) {
      return tablet;
    }
    return desktop;
  }

  /// Padding adapté au device
  EdgeInsets get responsivePadding =>
      EdgeInsets.all(responsiveSize(mobile: 12, tablet: 16, desktop: 20));

  /// Rayon de bordure adapté
  double get responsiveBorderRadius =>
      responsiveSize(mobile: 8, tablet: 12, desktop: 16);

  /// Espacement adapté
  double get responsiveSpacing =>
      responsiveSize(mobile: 8, tablet: 12, desktop: 16);

  /// Nombre de colonnes pour grid
  int get gridColumns => isDesktop
      ? 4
      : isTablet
      ? 2
      : 1;

  /// Hauteur d'un élément liste adapté
  double get listItemHeight =>
      responsiveSize(mobile: 60, tablet: 70, desktop: 80);

  /// Retourne true si l'écran est grand (>= 600px)
  bool get isLargeScreen => MediaQuery.of(this).size.width >= 600;

  /// Retourne true si l'écran est très grand (>= 1200px)
  bool get isXLargeScreen => MediaQuery.of(this).size.width >= 1200;

  /// Padding bottom (pour clavier)
  EdgeInsets get keyboardPadding =>
      EdgeInsets.only(bottom: MediaQuery.of(this).viewInsets.bottom);
}
