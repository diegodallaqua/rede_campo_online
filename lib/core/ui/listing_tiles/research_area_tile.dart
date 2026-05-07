import 'package:flutter/material.dart';
import '../../utils/models/research_areas.dart';
import '../theme/custom_colors.dart';

class ResearchAreaTile extends StatelessWidget {
  final ResearchAreas researchArea;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final bool green;

  const ResearchAreaTile({
    super.key,
    required this.researchArea,
    this.onTap,
    this.margin,
    this.green = false,
  });

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 12.0;
    const double fontSize = 14.0;
    const double horizontalPadding = 12.0;
    const double verticalPadding = 8.0;

    final Color backgroundColor = green
        ? CustomColors.pine_shadow
        : CustomColors.concrete_mist;

    final Color textColor = green
        ? Colors.white
        : CustomColors.pine_shadow;

    final Border border = green
        ? Border.all(color: CustomColors.pine_shadow, width: 1.5)
        : Border.all(color: CustomColors.concrete_mist, width: 1.5);

    final FontWeight fontWeight = green
        ? FontWeight.w400
        : FontWeight.w900;

    final content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: Text(
        researchArea.name ?? '—',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
        ),
      ),
    );

    return Container(
      margin: margin,
      child: onTap == null
          ? content
          : Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: content,
        ),
      ),
    );
  }
}