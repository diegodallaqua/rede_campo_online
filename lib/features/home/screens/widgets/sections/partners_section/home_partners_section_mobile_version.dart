import 'package:flutter/material.dart';
import '../../../../../../core/models/partner.dart';
import '../../../../../../core/ui/listing_tiles/partners/partners_tile.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/theme/custom_text_styles.dart';
import '../../../../../../core/ui/widgets/section_title.dart';

/// Seção dos parceiros como rede vertical (ver [PartnerNodeMobileVersion]).
class HomePartnersSectionMobileVersion extends StatelessWidget {
  const HomePartnersSectionMobileVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CustomColors.vanilla_haze,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 36, 20, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionTitle.mobile(
              title: 'Parceiros Institucionais',
              color: CustomColors.copper_spice,
              centered: true,
            ),
            const SizedBox(height: 12),
            Text(
              'Conheça as instituições que apoiam nossa missão',
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyMobile.copyWith(
                color: CustomColors.pine_shadow.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            for (var i = 0; i < institutionalPartners.length; i++)
              PartnerNodeMobileVersion(
                partner: institutionalPartners[i],
                isFirst: i == 0,
                isLast: i == institutionalPartners.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}
