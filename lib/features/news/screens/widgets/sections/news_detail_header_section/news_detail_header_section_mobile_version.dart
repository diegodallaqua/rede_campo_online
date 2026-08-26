import 'package:flutter/material.dart';

import '../../../../../../core/ui/listing_tiles/research_areas/research_area_tile.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/news.dart';

class NewsDetailHeaderSectionMobileVersion extends StatelessWidget {
  final News news;

  const NewsDetailHeaderSectionMobileVersion({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.vanilla_haze,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (news.research_areas?.isNotEmpty == true) ...[
            Wrap(
              spacing: 8,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: news.research_areas!
                  .where((a) => a.name?.isNotEmpty == true)
                  .map((a) => ResearchAreaTile(
                        researchArea: a,
                        green: true,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            news.title ?? '-',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: CustomColors.copper_spice,
              fontFamily: 'RobotoSlab',
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
