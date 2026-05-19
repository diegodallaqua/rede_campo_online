import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class ListEmptyState extends StatelessWidget {
  final String message;
  final Color messageColor;
  final double height;

  const ListEmptyState({
    super.key,
    this.message = 'Nenhum item encontrado.',
    this.messageColor = CustomColors.pine_shadow,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: messageColor,
          ),
        ),
      ),
    );
  }
}
