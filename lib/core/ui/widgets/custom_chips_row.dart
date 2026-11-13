import 'package:flutter/material.dart';
import '../theme/custom_colors.dart';
import 'custom_chip.dart';

/// Chips que cabem na largura; o excedente vira um chip "...".
class CustomChipsRow extends StatelessWidget {
  final List<String> labels;
  final Color color;
  final double spacing;

  const CustomChipsRow({
    super.key,
    required this.labels,
    this.color = CustomColors.pine_shadow,
    this.spacing = 5,
  });

  static const String _overflowLabel = '...';

  // Mesmos valores usados por [CustomChip].
  static const TextStyle _chipTextStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static const double _chipHorizontalPadding = 12; // 6 de cada lado

  double _chipWidth(String label, TextScaler textScaler) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: _chipTextStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      textScaler: textScaler,
    )..layout();
    return painter.width + _chipHorizontalPadding;
  }

  @override
  Widget build(BuildContext context) {
    if (labels.isEmpty) return const SizedBox.shrink();

    final textScaler = MediaQuery.textScalerOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final overflowWidth = _chipWidth(_overflowLabel, textScaler);

        final widths = labels
            .map((label) => _chipWidth(label, textScaler))
            .toList(growable: false);

        int visibleCount = 0;
        double used = 0;

        for (var i = 0; i < labels.length; i++) {
          final needed = used + (i == 0 ? 0 : spacing) + widths[i];
          final hasMoreAfter = i < labels.length - 1;
          // Reserva espaço para o "..." se sobrarem chips.
          final withIndicator =
              hasMoreAfter ? needed + spacing + overflowWidth : needed;

          if (withIndicator > maxWidth) break;

          used = needed;
          visibleCount++;
        }

        // Nada coube: mostra só o primeiro chip, truncado.
        if (visibleCount == 0) {
          return Row(
            children: [
              Flexible(child: CustomChip(label: labels.first, color: color)),
            ],
          );
        }

        final hasHidden = visibleCount < labels.length;

        return Row(
          children: [
            for (var i = 0; i < visibleCount; i++) ...[
              if (i > 0) SizedBox(width: spacing),
              CustomChip(label: labels[i], color: color),
            ],
            if (hasHidden) ...[
              SizedBox(width: spacing),
              CustomChip(label: _overflowLabel, color: color),
            ],
          ],
        );
      },
    );
  }
}
