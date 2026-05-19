import 'package:flutter/material.dart';
import '../../../../core/ui/listing_tiles/partners_tile.dart';
import '../../../../core/ui/theme/custom_colors.dart';

class HomePartnersSectionDesktopVersion extends StatelessWidget {
  const HomePartnersSectionDesktopVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 40, 48, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Parceiros Institucionais',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: CustomColors.copper_spice,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 64,
                height: 3,
                decoration: BoxDecoration(
                  color: CustomColors.copper_spice,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Conheça as instituições que apoiam nossa missão',
                style: TextStyle(
                  fontSize: 15,
                  color: CustomColors.pine_shadow.withOpacity(0.6),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 36),
              const Wrap(
                spacing: 28,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  PartnerTile(
                    imagePath: 'assets/images/utfpr.png',
                    width: 240,
                    height: 120,
                  ),
                  PartnerTile(
                    imagePath: 'assets/images/senar.png',
                    width: 240,
                    height: 120,
                  ),
                  PartnerTile(
                    imagePath: 'assets/images/idr.png',
                    width: 240,
                    height: 120,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
