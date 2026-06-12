import 'package:flutter/material.dart';

import '../theme/custom_colors.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelLabel = 'Cancelar',
    this.confirmLabel = 'Confirmar',
    this.confirmColor = CustomColors.danger_red,
  });

  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final Color confirmColor;

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String cancelLabel = 'Cancelar',
    String confirmLabel = 'Confirmar',
    Color confirmColor = CustomColors.danger_red,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: title,
        message: message,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
        confirmColor: confirmColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: CustomColors.midnight_slate,
          fontSize: 17,
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          color: CustomColors.midnight_slate.withOpacity(0.55),
          fontSize: 14,
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancelLabel,
            style:
                TextStyle(color: CustomColors.midnight_slate.withOpacity(0.55)),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            confirmLabel,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
