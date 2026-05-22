import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class ListEmptyState extends StatelessWidget {
  final String message;
  final Color messageColor;
  final double height;
  final Color? iconColor;

  const ListEmptyState({
    super.key,
    this.message = 'Nenhum item encontrado.',
    this.messageColor = CustomColors.pine_shadow,
    this.height = 200,
    this.iconColor = CustomColors.vanilla_haze,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 36,
              color: iconColor,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: messageColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
