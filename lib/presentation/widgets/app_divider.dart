import "package:flutter/material.dart";
import "package:shop_hub/core/theme/app_spacing.dart";

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.width = 10,
    this.color,
    this.thickness = AppSpacing.dividerThickness,
    this.height = 2,
    this.label = "",
    this.textColor,
    this.indent = AppSpacing.dividerIndent,
    this.endIndent = AppSpacing.dividerIndent,
    this.margin = AppSpacing.insetVSm,
    this.style,
    this.child,
    this.textPosition = 50,
  });

  final Color? textColor;
  final Widget? child;
  final Color? color;
  final double width;
  final double thickness;
  final double indent;
  final double endIndent;
  final double height;
  final String? label;
  final TextStyle? style;
  final EdgeInsetsGeometry margin;
  final double textPosition;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Assurez-vous que textPosition est entre 0 et 100
    final adjustedTextPosition = textPosition.clamp(0, 100);

    // Calculez les valeurs flex basées sur textPosition
    final leftFlex = adjustedTextPosition.round();
    final rightFlex = (100 - adjustedTextPosition).round();

    return Container(
      margin: margin,
      padding: EdgeInsets.zero,
      child: (child == null && (label == null || label!.isEmpty))
          ? Divider(
              thickness: thickness,
              color: color ?? theme.primaryColor,
              indent: indent,
              endIndent: endIndent,
            )
          : Row(
              children: [
                // Premier Expanded pour le Divider de gauche
                Expanded(
                  flex: leftFlex,
                  child: Divider(
                    thickness: thickness,
                    color: color ?? theme.primaryColor,
                    indent: indent,
                    endIndent: 0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ), // Vous pouvez ajuster le padding comme nécessaire
                  child:
                      child ??
                      Text(
                        label!,
                        style:
                            style ??
                            Theme.of(context).textTheme.bodyLarge!
                                .copyWith(color: textColor ?? color),
                      ),
                ),
                // Deuxième Expanded pour le Divider de droite
                Expanded(
                  flex: rightFlex,
                  child: Divider(
                    thickness: thickness,
                    color: color ?? theme.primaryColor,
                    indent: 0,
                    endIndent: endIndent,
                  ),
                ),
              ],
            ),
    );
  }
}
