import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../../core/ui/listing_tiles/research_areas/research_area_tile.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/dialogs/image_viewer_dialog.dart';
import '../../../../../../core/utils/placeholders.dart';
import '../../../../models/news.dart';
import '../../../../stores/news_detail_store.dart';

class NewsDetailHeaderSectionDesktopVersion extends StatelessWidget {
  final News news;
  final NewsDetailStore newsDetailStore;

  const NewsDetailHeaderSectionDesktopVersion({
    super.key,
    required this.news,
    required this.newsDetailStore,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    const months = [
      'Jan.',
      'Fev.',
      'Mar.',
      'Abr.',
      'Mai.',
      'Jun.',
      'Jul.',
      'Ago.',
      'Set.',
      'Out.',
      'Nov.',
      'Dez.',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.vanilla_haze,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (news.research_areas?.isNotEmpty == true) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: news.research_areas!
                              .where((a) => a.name?.isNotEmpty == true)
                              .map((a) => ResearchAreaTile(
                                    researchArea: a,
                                    green: true,
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                      Text(
                        news.title ?? '—',
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          color: CustomColors.midnight_slate,
                          fontFamily: 'RobotoSlab',
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 56,
                        height: 4,
                        decoration: BoxDecoration(
                          color: CustomColors.copper_spice,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      if (news.publication_date != null) ...[
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: CustomColors.copper_spice,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Publicado em ${_formatDate(news.publication_date)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: CustomColors.pine_shadow,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 64),
                Expanded(
                  flex: 4,
                  child: Observer(
                    builder: (context) {
                      final viewable = newsDetailStore.media
                          .where((m) => m.media?.isNotEmpty == true)
                          .toList();
                      final cover = viewable.isNotEmpty ? viewable.first : null;

                      final image = AspectRatio(
                        aspectRatio: 4 / 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: cover != null
                              ? Image.network(
                                  cover.media!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const ImagePlaceholder(),
                                )
                              : const ImagePlaceholder(),
                        ),
                      );

                      if (cover == null) return image;

                      return GestureDetector(
                        onTap: () => ImageViewerDialog.show(
                          context: context,
                          imageUrls: viewable.map((m) => m.media!).toList(),
                          imageNames: viewable.map((m) => m.name).toList(),
                          initialIndex: 0,
                        ),
                        child: image,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
