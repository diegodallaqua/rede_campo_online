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
      height: 92,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: CustomColors.salt_flower,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CustomColors.soft_border),
        boxShadow: [
          BoxShadow(
            color: CustomColors.midnight_slate.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [CustomColors.copper_spice, CustomColors.fresh_sprout],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 88,
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CustomColors.soft_border),
            ),
            child: Image.asset(
              logoPath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: CustomColors.pine_shadow,
                      letterSpacing: 0.2,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontStyle: FontStyle.italic,
                      color: CustomColors.pine_shadow.withOpacity(0.65),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (onTap != null)
            const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Icon(
                Icons.north_east_rounded,
                size: 16,
                color: CustomColors.copper_spice,
              ),
            ),
        ],
      ),
    );

    if (onTap == null) return tile;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: tile,
      ),
    );
  }
}
