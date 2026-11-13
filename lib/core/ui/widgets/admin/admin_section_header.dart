import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

/// Cabeçalho das seções desktop do painel administrativo: título, subtítulo
/// e a ação principal da tela (por exemplo, "Nova notícia") à direita.
class AdminSectionHeader extends StatelessWidget {
  const AdminSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final label = actionLabel;

    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 40, 40, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AdminHeaderStyles.title),
                const SizedBox(height: 8),
                Text(subtitle, style: AdminHeaderStyles.subtitle),
              ],
            ),
          ),
          if (label != null && onAction != null)
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: Text(label),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.copper_spice,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Estilos de título e subtítulo compartilhados pelas telas desktop do
/// painel (listagens, início e formulários).
abstract class AdminHeaderStyles {
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: CustomColors.pine_shadow,
    letterSpacing: -0.5,
  );

  static final TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: CustomColors.pine_shadow.withOpacity(0.75),
  );
}
