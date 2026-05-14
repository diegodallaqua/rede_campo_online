import 'package:flutter/material.dart';
import '../../../../core/ui/theme/custom_colors.dart';
import '../../../../core/ui/listing_tiles/partners_tile.dart';

class PartnersSectionMobileVersion extends StatelessWidget {
  const PartnersSectionMobileVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Parceiros Institucionais',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: CustomColors.copper_spice,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Conheça as instituições que apoiam nossa missão',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: CustomColors.pine_shadow.withOpacity(0.6),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = (constraints.maxWidth - 12) / 2;
              return Column(
                children: [
                  Row(
                    children: [
                      PartnerTile(
                        imagePath: 'assets/images/utfpr.png',
                        width: tileWidth,
                        height: 90,
                      ),
                      const SizedBox(width: 12),
                      PartnerTile(
                        imagePath: 'assets/images/senar.png',
                        width: tileWidth,
                        height: 90,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PartnerTile(
                    imagePath: 'assets/images/idr.png',
                    width: tileWidth,
                    height: 90,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
