import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "app_colors.dart";
import "app_spacing.dart";
import "app_text_styles.dart";

/// Thème global de l'application shop_hub (Inspiré de Netflix).
class AppTheme {
  const AppTheme._();

  // ─────────────────────────────────────────────
  // FONTS
  // ─────────────────────────────────────────────

  static const String fontFamily = AppTextStyles.fontFamily;

  // ─────────────────────────────────────────────
  // SHAPES
  // ─────────────────────────────────────────────

  static const shapeLarge = RoundedRectangleBorder(
    borderRadius: AppSpacing.roundedXxl,
  );
  static const shapeMedium = RoundedRectangleBorder(
    borderRadius: AppSpacing.roundedLg,
  );
  static const shapeSmall = RoundedRectangleBorder(
    borderRadius: AppSpacing.roundedMd,
  );

  // -----------------------------------------------------------------------
  // COULEURS (ColorScheme)
  // -----------------------------------------------------------------------
  // Light : Scaffold blanc (#FFFFFF), cards gris chaud (#E9E9E7),
  //         primary charbon quasi-noir (#1C1B1F).
  // Dark  : Scaffold noir profond (#0F0F0F), cards (#1A1A1A),
  //         conteneurs (#242424), texte blanc pur.
  // -----------------------------------------------------------------------
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary, // #1C1B1F — charbon quasi-noir
    onPrimary: AppColors.white,
    secondary: AppColors.secondary, // #3D3B41 — charbon atténué
    onSecondary: AppColors.white,
    tertiary: AppColors.tertiary, // #E5A00D — or ambré
    onTertiary: AppColors.white,
    error: AppColors.error,
    onError: AppColors.white,
    surface: AppColors.surface, // #FFFFFF — scaffold blanc pur
    onSurface: AppColors.ink, // #1C1B1F — texte sombre
    surfaceContainer: AppColors.surfaceContainer, // #E9E9E7 — cards gris chaud
    onSurfaceVariant: AppColors.ink54,
    outline: AppColors.neutral300,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    // #1C1B1F — adaptée dark (onPrimary = white)
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    secondary: AppColors.secondary, // #3D3B41
    onSecondary: AppColors.paleMint,
    tertiary: AppColors.accentAmber, // Or pour accents
    onTertiary: AppColors.ink,
    error: AppColors.error,
    onError: AppColors.white,
    surface: AppColors.darkBackground, // #0F0F0F — noir profond
    onSurface: AppColors.paleMint, // #FFFFFF — texte clair
    surfaceContainer: AppColors.darkSurface, // #1A1A1A — cards dark
    onSurfaceVariant: AppColors.paleMint70, // texte secondaire atténué
    outline: AppColors.neutral700,
  );

  // ─────────────────────────────────────────────
  // LIGHT THEME
  // ─────────────────────────────────────────────

  static final lightTheme = ThemeData(
    fontFamily: fontFamily,
    brightness: Brightness.light,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: AppColors.surface, // #FFFFFF — blanc pur
    // Text theme
    textTheme: AppTextStyles.lightTextTheme.apply(
      fontFamily: fontFamily,
      bodyColor: lightColorScheme.onSurface,
      displayColor: lightColorScheme.onSurface,
    ),

    // AppBar — fond blanc, aucune séparation visible
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: lightColorScheme.onSurface,
      elevation: AppSpacing.elevationNone,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: lightColorScheme.onSurface,
        letterSpacing: 0.2,
        fontFamily: fontFamily,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        elevation: AppSpacing.elevationSm,
        shadowColor: lightColorScheme.primary.withValues(alpha: 0.25),
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXl),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          fontFamily: fontFamily,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightColorScheme.onSurface,
        side: const BorderSide(color: AppColors.neutral300, width: 1.5),
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXl),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          fontFamily: fontFamily,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightColorScheme.primary,
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXl),
        textStyle: AppTextStyles.buttonText,
      ),
    ),

    // Input Decoration (TextField)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightInput,
      contentPadding: AppSpacing.inputPadding,
      border: const OutlineInputBorder(
        borderRadius: AppSpacing.roundedXl,
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.roundedXl,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedXl,
        borderSide: BorderSide(
          color: lightColorScheme.primary,
          width: AppSpacing.borderWidthThick,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedXl,
        borderSide: BorderSide(
          color: lightColorScheme.error,
          width: AppSpacing.borderWidthMedium,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedXl,
        borderSide: BorderSide(
          color: lightColorScheme.error,
          width: AppSpacing.borderWidthThick,
        ),
      ),
      labelStyle: TextStyle(
        color: lightColorScheme.onSurfaceVariant,
        fontFamily: fontFamily,
      ),
      hintStyle: const TextStyle(
        color: AppColors.neutral500,
        fontFamily: fontFamily,
      ),
    ),

    // Card — fond gris chaud (#E9E9E7), très arrondi
    cardTheme: CardThemeData(
      color: AppColors.surfaceContainer, // #E9E9E7
      elevation: AppSpacing.elevationNone,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXxl),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shadowColor: Colors.black.withValues(alpha: 0.04),
    ),

    // FloatingActionButton
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
      elevation: AppSpacing.elevationMd,
      shape: const CircleBorder(),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surface, // blanc pur
      elevation: AppSpacing.elevationLg,
      selectedItemColor: lightColorScheme.primary,
      unselectedItemColor: AppColors.neutral400,
      selectedLabelStyle: AppTextStyles.lightTextTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: AppTextStyles.lightTextTheme.labelSmall,
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXxl),
      titleTextStyle: AppTextStyles.lightTextTheme.titleLarge,
      contentTextStyle: AppTextStyles.lightTextTheme.bodyMedium,
    ),

    // SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primary,
      contentTextStyle: AppTextStyles.darkTextTheme.bodyMedium,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXl),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceContainer, // #E9E9E7
      selectedColor: lightColorScheme.primary,
      secondarySelectedColor: lightColorScheme.primary,
      labelStyle: AppTextStyles.lightTextTheme.labelMedium,
      secondaryLabelStyle: AppTextStyles.lightTextTheme.labelMedium?.copyWith(
        color: AppColors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXl),
      side: BorderSide.none,
    ),

    // Autres composants
    iconTheme: IconThemeData(
      color: lightColorScheme.onSurface,
      size: AppSpacing.iconLg,
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: lightColorScheme.primary,
      circularTrackColor: AppColors.neutral200,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.neutral200,
      thickness: AppSpacing.dividerThickness,
      space: AppSpacing.dividerThickness,
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.white;
        }
        return AppColors.neutral400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColorScheme.primary;
        }
        return AppColors.neutral200;
      }),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColorScheme.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.white),
      side: const BorderSide(color: AppColors.neutral300, width: 1.5),
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedSm),
    ),

    // Radio
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColorScheme.primary;
        }
        return AppColors.neutral400;
      }),
    ),
  );

  // ─────────────────────────────────────────────
  // DARK THEME (Signature Dark — 3 niveaux de surfaces)
  // ─────────────────────────────────────────────

  static final darkTheme = ThemeData(
    fontFamily: fontFamily,
    brightness: Brightness.dark,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: AppColors.darkBackground, // #0F0F0F
    // Text theme
    textTheme: AppTextStyles.darkTextTheme.apply(
      fontFamily: fontFamily,
      bodyColor: darkColorScheme.onSurface,
      displayColor: darkColorScheme.onSurface,
    ),

    // AppBar — fond transparent (révèle le scaffold noir)
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: darkColorScheme.onSurface,
      elevation: AppSpacing.elevationNone,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: darkColorScheme.onSurface,
        letterSpacing: 0.2,
        fontFamily: fontFamily,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        elevation: AppSpacing.elevationSm,
        shadowColor: Colors.black.withValues(alpha: 0.6),
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXl),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          fontFamily: fontFamily,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkColorScheme.onSurface,
        side: const BorderSide(color: AppColors.neutral600, width: 1.5),
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXl),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          fontFamily: fontFamily,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.paleMint,
        minimumSize: const Size(0, AppSpacing.buttonHeightLg),
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXl),
        textStyle: AppTextStyles.buttonText,
      ),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        padding: AppSpacing.insetMd,
        backgroundColor: AppColors.paleMint54,
        shape: const CircleBorder(),
        iconSize: AppSpacing.iconMxl,
      ),
    ),

    // Input Decoration (TextField)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkInput, // #2E2E2E
      contentPadding: AppSpacing.inputPadding,
      border: const OutlineInputBorder(
        borderRadius: AppSpacing.roundedXl,
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.roundedXl,
        borderSide: BorderSide.none,
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: AppSpacing.roundedXl,
        borderSide: BorderSide(
          color: AppColors.paleMint,
          width: AppSpacing.borderWidthThick,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedXl,
        borderSide: BorderSide(
          color: darkColorScheme.error,
          width: AppSpacing.borderWidthMedium,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.roundedXl,
        borderSide: BorderSide(
          color: darkColorScheme.error,
          width: AppSpacing.borderWidthThick,
        ),
      ),
      labelStyle: const TextStyle(
        color: AppColors.paleMint54,
        fontFamily: fontFamily,
      ),
      hintStyle: const TextStyle(
        color: AppColors.paleMint38,
        fontFamily: fontFamily,
      ),
    ),

    // Card — level 1 surface (#1A1A1A), très arrondi
    cardTheme: CardThemeData(
      color: AppColors.darkSurface, // #1A1A1A
      elevation: AppSpacing.elevationNone,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXxl),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shadowColor: Colors.black.withValues(alpha: 0.5),
    ),

    // FloatingActionButton
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
      elevation: AppSpacing.elevationMd,
      shape: const CircleBorder(),
    ),

    // Bottom Navigation Bar — fond noir profond
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.darkBackground, // #0F0F0F
      elevation: AppSpacing.elevationLg,
      selectedItemColor: AppColors.paleMint,
      unselectedItemColor: AppColors.paleMint54,
      selectedLabelStyle: AppTextStyles.darkTextTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: AppTextStyles.darkTextTheme.labelSmall,
    ),

    // Dialog — surface level 1
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkSurface, // #1A1A1A
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXxl),
      titleTextStyle: AppTextStyles.darkTextTheme.titleLarge,
      contentTextStyle: AppTextStyles.darkTextTheme.bodyMedium,
    ),

    // SnackBar — surface level 2
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkSurfaceContainer, // #242424
      contentTextStyle: AppTextStyles.darkTextTheme.bodyMedium,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXl),
    ),

    // Chip — surface level 2
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurfaceContainer, // #242424
      selectedColor: AppColors.paleMint,
      secondarySelectedColor: AppColors.paleMint,
      labelStyle: AppTextStyles.darkTextTheme.labelMedium,
      secondaryLabelStyle: AppTextStyles.darkTextTheme.labelMedium?.copyWith(
        color: AppColors.darkBackground,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedXl),
      side: BorderSide.none,
    ),

    // Autres composants
    iconTheme: const IconThemeData(
      color: AppColors.paleMint,
      size: AppSpacing.iconLg,
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: darkColorScheme.primary,
      circularTrackColor: AppColors.neutral700,
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.neutral800,
      thickness: AppSpacing.dividerThickness,
      space: AppSpacing.dividerThickness,
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.darkBackground;
        }
        return AppColors.neutral500;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.paleMint;
        }
        return AppColors.neutral700;
      }),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.paleMint;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.darkBackground),
      side: const BorderSide(color: AppColors.neutral600, width: 1.5),
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedSm),
    ),

    // Radio
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.paleMint;
        }
        return AppColors.neutral600;
      }),
    ),
  );
}
