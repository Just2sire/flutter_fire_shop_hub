import "package:flutter/material.dart";
import "package:shop_hub/core/theme/app_spacing.dart";

/// Position of the text label relative to the progress bar.
enum AppProgressLabelPosition {
  /// Displays label on top of the progress bar.
  top,

  /// Displays label below the progress bar.
  bottom,

  /// Displays label to the right of the progress bar.
  right,

  /// Displays label centered inside the progress bar.
  inside,
}

/// A customizable, animated progress indicator widget.
///
/// Automatically animates from 0 (or previous value) to the given [value].
/// Highly customizable via its properties including colors, gradients,
/// dimensions, borders, animation curves, durations, and text labels.
class AppProgressIndicator extends StatelessWidget {
  /// Creates an [AppProgressIndicator].
  const AppProgressIndicator({
    required this.value,
    super.key,
    this.minValue = 0.0,
    this.maxValue = 1.0,
    this.height = 12.0,
    this.width,
    this.duration = AppSpacing.durationXSlow,
    this.curve = Curves.easeOutCubic,
    this.backgroundColor,
    this.valueColor,
    this.gradient,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.showLabel = false,
    this.labelPosition = AppProgressLabelPosition.right,
    this.labelStyle,
    this.labelBuilder,
    this.customLabelWidget,
    this.margin,
    this.padding,
    this.animated = true,
    this.onEnd,
  });

  /// The current progress target value.
  final double value;

  /// The minimum value of the progress indicator (defaults to `0.0`).
  final double minValue;

  /// The maximum value of the progress indicator (defaults to `1.0`).
  final double maxValue;

  /// Height of the progress bar track.
  final double height;

  /// Optional width constraint for the progress indicator container.
  final double? width;

  /// Duration of the animation when changing values.
  final Duration duration;

  /// Curve of the progress animation.
  final Curve curve;

  /// Background color of the progress bar track.
  final Color? backgroundColor;

  /// Fill color of the progress bar (used if [gradient] is null).
  final Color? valueColor;

  /// Gradient for the progress bar fill. Overrides [valueColor] if provided.
  final Gradient? gradient;

  /// Border radius for track and filled indicator.
  final BorderRadiusGeometry? borderRadius;

  /// Optional border color for the track container.
  final Color? borderColor;

  /// Optional border width for the track container.
  final double? borderWidth;

  /// Whether to display a text label showing progress.
  final bool showLabel;

  /// Position of the text label relative to the progress bar.
  final AppProgressLabelPosition labelPosition;

  /// Custom text style for the progress label.
  final TextStyle? labelStyle;

  /// Custom string builder for formatting the text label.
  /// Passes `(animatedValue, percentage)` as arguments.
  final String Function(double animatedValue, double percentage)? labelBuilder;

  /// Custom widget builder for rendering a customized label widget.
  /// Passes `(animatedValue, percentage)` as arguments.
  final Widget Function(double animatedValue, double percentage)?
  customLabelWidget;

  /// Outer margin around the progress indicator component.
  final EdgeInsetsGeometry? margin;

  /// Internal padding within the progress indicator container.
  final EdgeInsetsGeometry? padding;

  /// Whether to animate value changes smoothly.
  final bool animated;

  /// Callback triggered when the progress animation completes.
  final VoidCallback? onEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final range = maxValue - minValue;
    final safeRange = range <= 0 ? 1.0 : range;
    final clampedValue = value.clamp(minValue, maxValue);
    final targetNormalized = (clampedValue - minValue) / safeRange;

    return Container(
      margin: margin,
      padding: padding,
      width: width,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: targetNormalized),
        duration: animated ? duration : Duration.zero,
        curve: curve,
        onEnd: onEnd,
        builder: (context, animFraction, child) {
          final currentAnimatedValue = minValue + (animFraction * safeRange);
          final percentage = animFraction * 100.0;

          final progressBar = _buildProgressBar(animFraction, theme);

          if (!showLabel) {
            return progressBar;
          }

          final labelWidget = _buildLabel(
            currentAnimatedValue,
            percentage,
            theme,
          );

          switch (labelPosition) {
            case AppProgressLabelPosition.top:
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [labelWidget, AppSpacing.gapVSm, progressBar],
              );
            case AppProgressLabelPosition.bottom:
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [progressBar, AppSpacing.gapVSm, labelWidget],
              );
            case AppProgressLabelPosition.right:
              return Row(
                children: [
                  Expanded(child: progressBar),
                  AppSpacing.gapHSm,
                  labelWidget,
                ],
              );
            case AppProgressLabelPosition.inside:
              return Stack(
                alignment: Alignment.center,
                children: [progressBar, labelWidget],
              );
          }
        },
      ),
    );
  }

  Widget _buildProgressBar(double animFraction, ThemeData theme) {
    final effectiveRadius = borderRadius ?? AppSpacing.roundedFull;
    final trackColor =
        backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final fillColor = valueColor ?? theme.colorScheme.primary;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: effectiveRadius,
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth ?? AppSpacing.borderWidthBase,
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final filledWidth = totalWidth * animFraction;

            return Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: Duration.zero,
                width: filledWidth,
                height: height,
                decoration: BoxDecoration(
                  color: gradient == null ? fillColor : null,
                  gradient: gradient,
                  borderRadius: effectiveRadius,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(
    double currentAnimatedValue,
    double percentage,
    ThemeData theme,
  ) {
    if (customLabelWidget != null) {
      return customLabelWidget!(currentAnimatedValue, percentage);
    }

    final labelText = labelBuilder != null
        ? labelBuilder!(currentAnimatedValue, percentage)
        : "${percentage.round()}%";

    final defaultStyle = theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
    );

    return Text(labelText, style: labelStyle ?? defaultStyle);
  }
}
