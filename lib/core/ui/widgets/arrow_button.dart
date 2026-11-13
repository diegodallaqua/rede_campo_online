import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class ArrowButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  final Color iconColor;

  // Se definido, desabilitado muda a cor do ícone em vez da opacidade.
  final Color? disabledIconColor;

  final Color backgroundColor;
  final double iconSize;
  final double borderRadius;
  final Border? border;

  // Se definido, botão quadrado de tamanho fixo.
  final double? fixedSize;

  // Só usado sem fixedSize.
  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry? margin;

  // Opacidade desabilitada; ignorada com disabledIconColor.
  final double disabledOpacity;

  // true → Material + InkWell (ripple); false → GestureDetector + Container.
  final bool useRipple;

  const ArrowButton({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onTap,
    this.iconColor = CustomColors.copper_spice,
    this.disabledIconColor,
    this.backgroundColor = Colors.transparent,
    this.iconSize = 28,
    this.borderRadius = 24,
    this.border,
    this.fixedSize,
    this.padding = const EdgeInsets.all(8),
    this.margin,
    this.disabledOpacity = 0.2,
    this.useRipple = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveIconColor =
        enabled ? iconColor : (disabledIconColor ?? iconColor);
    final double effectiveOpacity =
        disabledIconColor != null ? 1.0 : (enabled ? 1.0 : disabledOpacity);

    final Widget iconWidget =
        Icon(icon, color: effectiveIconColor, size: iconSize);

    final Widget content = fixedSize != null
        ? SizedBox(
            width: fixedSize,
            height: fixedSize,
            child: Center(child: iconWidget),
          )
        : Padding(padding: padding, child: iconWidget);

    final Widget button = useRipple
        ? Material(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            child: InkWell(
              onTap: enabled ? onTap : null,
              borderRadius: BorderRadius.circular(borderRadius),
              child: content,
            ),
          )
        : GestureDetector(
            onTap: enabled ? onTap : null,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(borderRadius),
                border: border,
              ),
              child: content,
            ),
          );

    final Widget result = AnimatedOpacity(
      opacity: effectiveOpacity,
      duration: const Duration(milliseconds: 200),
      child: button,
    );

    return margin != null ? Padding(padding: margin!, child: result) : result;
  }
}
