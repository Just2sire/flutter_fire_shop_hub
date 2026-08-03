import "package:flutter/material.dart";
import "package:shop_hub/core/theme/app_spacing.dart";

class AppStepIndicator extends StatelessWidget {
  const AppStepIndicator({
    required this.currentStep,
    required this.totalSteps,
    super.key,
    this.dotSize = 10.0,
    this.spacing = 8.0,
    this.height,
    this.width,
    this.selectedScale = 3.5,
    this.activeColor,
    this.inactiveColor = Colors.grey,
    this.curve = AppSpacing.curveDefault,
    this.duration = AppSpacing.durationBase,
  });

  final int currentStep;
  final int totalSteps;
  final double? height;
  final double? width;
  final double selectedScale;
  final double dotSize;
  final double spacing;
  final Color? activeColor;
  final Color? inactiveColor;
  final Curve? curve;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.brightness == Brightness.dark
        ? theme.colorScheme.secondary
        : theme.colorScheme.primary;
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (index) {
          return AnimatedContainer(
            duration: duration,
            curve: AppSpacing.curveDefault,
            width: index == currentStep ? dotSize * selectedScale : dotSize,
            height: dotSize,
            margin: EdgeInsets.symmetric(horizontal: spacing / 2),
            decoration: BoxDecoration(
              color: index == currentStep
                  ? (activeColor ?? primaryColor)
                  : (inactiveColor ?? theme.colorScheme.onSurface),
              borderRadius: BorderRadius.circular(dotSize),
            ),
          );
        }),
      ),
    );
  }
}
