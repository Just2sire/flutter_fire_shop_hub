import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shop_hub/core/theme/app_theme.dart";

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.light;
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeMode get theme => state;

  set theme(ThemeMode theme) {
    state = theme;
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

final lightThemeProvider = Provider((ref) => AppTheme.lightTheme);
final darkThemeProvider = Provider((ref) => AppTheme.darkTheme);
