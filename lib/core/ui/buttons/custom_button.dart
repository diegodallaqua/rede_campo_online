import 'package:flutter/material.dart';
import '../theme/custom_colors.dart';
import '../theme/custom_text_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.width,
      required this.color,
      required this.text,
      required this.function,
      this.textColor,
      this.borderRadius,
      this.fontWeight,
      this.height = 45,
      this.elevation = 8,
      this.borderColor,
      this.trailingIcon});

  final double? width;
  final Color color;
  final Color? textColor;
  final String text;
  final Function()? function;
  final double? borderRadius;
  final FontWeight? fontWeight;
  final double height;
  final double elevation;

  /// Contorno de 1.5px (botão secundário).
  final Color? borderColor;

  /// Ícone após o texto.
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final foreground = textColor ?? CustomColors.fresh_sprout;

    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 24),
            ),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1.5)
                : null,
            backgroundColor: color,
            foregroundColor: foreground,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            elevation: elevation,
            shadowColor: CustomColors.midnight_slate.withOpacity(0.25)),
        onPressed: function,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: CustomTextStyles.button.copyWith(
                  color: foreground,
                  fontWeight: fontWeight ?? FontWeight.w600,
                ),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 10),
              Icon(trailingIcon, size: 20, color: foreground),
            ],
          ],
        ),
      ),
    );
  }
}
