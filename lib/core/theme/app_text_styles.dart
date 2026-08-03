import "package:flutter/material.dart" show TextTheme, FontWeight, TextStyle;

import "app_colors.dart";

class AppTextStyles {
  const AppTextStyles._();

  static const String fontFamily = "Fellix";

  static const lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      color: AppColors.ink,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      color: AppColors.ink,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: AppColors.ink,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: AppColors.ink,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: AppColors.ink,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: AppColors.ink,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: AppColors.ink,
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: AppColors.ink,
    ),
    titleSmall: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w500,
      color: AppColors.ink,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: AppColors.ink87,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.ink87,
    ),
    bodySmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.ink54,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.ink87,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.ink87,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.ink87,
    ),
  );

  static const darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      color: AppColors.paleMint,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      color: AppColors.paleMint,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: AppColors.paleMint,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: AppColors.paleMint,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: AppColors.paleMint,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: AppColors.paleMint,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: AppColors.paleMint,
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: AppColors.paleMint,
    ),
    titleSmall: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w500,
      color: AppColors.paleMint,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: AppColors.paleMint87,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.paleMint87,
    ),
    bodySmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.paleMint54,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.paleMint87,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.paleMint87,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.paleMint70,
    ),
  );

  static TextStyle buttonText = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.43,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle inputText = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static TextStyle inputLabel = const TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 1.33,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
  );
}
