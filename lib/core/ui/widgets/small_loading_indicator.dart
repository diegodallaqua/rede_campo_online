import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

/// Indicador de progresso compacto usado em rodapés de lista e seções de
/// formulário enquanto dados pontuais carregam.
class SmallLoadingIndicator extends StatelessWidget {
  const SmallLoadingIndicator({
    super.key,
    this.size = 24,
    this.color = CustomColors.copper_spice,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(strokeWidth: 2, color: color),
    );
  }
}
