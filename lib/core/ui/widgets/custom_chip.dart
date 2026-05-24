import 'package:flutter/material.dart';
import '../theme/custom_colors.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final Color color;

  const CustomChip({
    super.key,
    required this.label,
    this.color = CustomColors.pine_shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
          height: 1.3,
        ),
      ),
    );
  }
}
