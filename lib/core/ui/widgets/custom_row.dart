import 'package:flutter/material.dart';
import '../theme/custom_colors.dart';

class CustomRow extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final IconData icon;
  final Color iconColor;
  final double iconSize;

  const CustomRow(
      {super.key,
      required this.icon,
      required this.text,
      this.iconColor = CustomColors.copper_spice,
      this.textColor = CustomColors.pine_shadow,
      this.iconSize = 14,
      this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: iconSize, color: iconColor),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
