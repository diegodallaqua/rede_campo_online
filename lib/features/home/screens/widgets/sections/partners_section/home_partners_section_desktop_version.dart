import 'package:flutter/material.dart';
import '../../../../../../core/models/partner.dart';
import '../../../../../../core/ui/listing_tiles/partners/partners_tile.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/theme/custom_text_styles.dart';
import '../../../../../../core/ui/widgets/section_title.dart';

/// Seção dos parceiros como rede (ver [PartnerNodeDesktopVersion]).
class HomePartnersSectionDesktopVersion extends StatelessWidget {
  const HomePartnersSectionDesktopVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CustomColors.vanilla_haze,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(48, 64, 48, 72),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SectionTitle(
                  title: 'Parceiros Institucionais',
                  color: CustomColors.copper_spice,
                  centered: true,
                ),
                const SizedBox(height: 16),
                Text(
                  'Conheça as instituições que apoiam nossa missão',
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.bodyDesktop.copyWith(
                    color: CustomColors.pine_shadow.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 48),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < institutionalPartners.length; i++)
                      Expanded(
                        child: PartnerNodeDesktopVersion(
                          partner: institutionalPartners[i],
                          isFirst: i == 0,
                          isLast: i == institutionalPartners.length - 1,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
