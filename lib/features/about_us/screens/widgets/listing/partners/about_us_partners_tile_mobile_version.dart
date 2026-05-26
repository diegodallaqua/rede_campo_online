import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';

class AboutUsPartnersTileMobileVersion extends StatelessWidget {
  final String logoPath;
  final String name;
  final String description;
  final VoidCallback? onTap;

  const AboutUsPartnersTileMobileVersion({
    super.key,
    required this.logoPath,
    required this.name,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      decoration: BoxDecoration(
        color: CustomColors.honey_cream,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CustomColors.midnight_slate.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Image.asset(
              logoPath,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            width: 1,
            height: 52,
            color: CustomColors.midnight_slate.withOpacity(0.12),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: CustomColors.pine_shadow,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: CustomColors.pine_shadow,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return tile;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: tile,
      ),
    );
  }
}
