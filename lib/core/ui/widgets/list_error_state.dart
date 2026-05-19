import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class ListErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  final Color iconColor;
  final String message;
  final Color messageColor;
  final double height;

  const ListErrorState({
    super.key,
    required this.onRetry,
    this.iconColor = CustomColors.pine_shadow,
    this.message = 'Não foi possível carregar os dados.',
    this.messageColor = CustomColors.pine_shadow,
    this.height = 300,
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
              Icons.wifi_off_rounded,
              color: iconColor,
              size: 32,
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
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Tentar novamente',
                style: TextStyle(
                  fontSize: 12,
                  color: messageColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
