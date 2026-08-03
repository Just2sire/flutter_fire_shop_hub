import "dart:ui";

extension ColorExtension on Color {
  Color addOpacity(double value) {
    return withValues(alpha: value);
  }
}
