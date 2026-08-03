import "package:flutter/material.dart";

/// Extension principale pour BuildContext
/// Fournit accès facile aux propriétés les plus courantes
extension BuildContextExtensions on BuildContext {
  // ═══════════════════════════════════════════════════════════════
  // 🎨 THÈME & APPARENCE
  // ═══════════════════════════════════════════════════════════════

  /// Accès au thème de l'application
  ThemeData get theme => Theme.of(this);

  /// Accès à la palette de couleurs
  ColorScheme get colorScheme => theme.colorScheme;

  /// Accès aux styles de texte
  TextTheme get textTheme => theme.textTheme;

  /// Vérifie si on est en mode sombre
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Couleur de fond du scaffold
  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  /// Couleur primaire
  Color get primaryColor => theme.primaryColor;

  /// Couleur d'accent
  Color get accentColor => colorScheme.secondary;

  /// Couleur d'erreur
  Color get errorColor => colorScheme.error;

  // ═══════════════════════════════════════════════════════════════
  // 📐 RESPONSIVE DESIGN
  // ═══════════════════════════════════════════════════════════════

  /// Taille complète de l'écran
  Size get screenSize => MediaQuery.of(this).size;

  /// Largeur de l'écran
  double get screenWidth => screenSize.width;

  /// Hauteur de l'écran
  double get screenHeight => screenSize.height;

  /// Vérifie si l'appareil est mobile
  /// (< 600px de largeur)
  bool get isMobile => screenWidth < 600;

  /// Vérifie si l'appareil est une tablette
  /// (600px - 1200px de largeur)
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// Vérifie si l'appareil est un desktop
  /// (>= 1200px de largeur)
  bool get isDesktop => screenWidth >= 1200;

  /// Orientation de l'écran (portrait/paysage)
  Orientation get orientation => MediaQuery.of(this).orientation;

  /// Vérifie l'orientation portrait
  bool get isPortrait => orientation == Orientation.portrait;

  /// Vérifie l'orientation paysage
  bool get isLandscape => orientation == Orientation.landscape;

  /// Padding de sécurité (notches, etc.)
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Padding pour clavier virtuel
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  // ═══════════════════════════════════════════════════════════════
  // 🧭 NAVIGATION
  // ═══════════════════════════════════════════════════════════════

  /// Pop la page actuelle
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  /// Vérifie si on peut revenir en arrière
  bool get canPop => Navigator.of(this).canPop();

  // ═══════════════════════════════════════════════════════════════
  // 🔔 FEEDBACK UTILISATEUR
  // ═══════════════════════════════════════════════════════════════

  /// Affiche une snackbar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
        action: action,
      ),
    );
  }

  /// Affiche une erreur (snackbar rouge)
  void showError(String message) {
    showSnackBar(
      message,
      backgroundColor: errorColor,
      duration: const Duration(seconds: 3),
    );
  }

  /// Affiche un succès (snackbar vert)
  void showSuccess(String message) {
    showSnackBar(message, backgroundColor: Colors.green);
  }

  /// Affiche un message informatif
  void showInfo(String message) {
    showSnackBar(message, backgroundColor: Colors.blue);
  }

  /// Affiche un dialog de confirmation
  Future<bool?> showConfirmDialog({
    required String title,
    required String content,
    String confirmLabel = "Confirmer",
    String cancelLabel = "Annuler",
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: context.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(content, style: context.textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelLabel,
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? primaryColor,
            ),
            child: Text(
              confirmLabel,
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Affiche un dialog d'information
  Future<void> showInfoDialog({
    required String title,
    required String content,
    String buttonLabel = "OK",
  }) {
    return showDialog<void>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}
