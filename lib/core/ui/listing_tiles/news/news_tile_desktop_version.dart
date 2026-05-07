import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import '../../../../features/news/models/news.dart';
import '../../../../features/news/models/news_media.dart';
import '../../../../features/projects/models/projects.dart';
import '../../../utils/placeholders.dart';
import '../../theme/custom_colors.dart';

class NewsTileDesktopVersion extends StatelessWidget {
  final News news;
  final NewsMedia? newsMedia;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const NewsTileDesktopVersion({
    super.key,
    required this.news,
    this.newsMedia,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 350.0;
    const double coverHeight = 200.0;
    const double borderRadius = 12.0;
    const double titleFontSize = 14.0;
    const double textFontSize = 12.0;

    final content = Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: CustomColors.honey_cream,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
            child: SizedBox(
              height: coverHeight,
              child: newsMedia != null && newsMedia!.media != null && newsMedia!.media!.isNotEmpty
                  ? Image.network(
                    newsMedia!.media!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const ImagePlaceholder(),
              ) : const ImagePlaceholder(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title ?? '—',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.pine_shadow,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 6),

                if (news.publication_date != null) ...[
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: textFontSize,
                        color: CustomColors.pine_shadow,
                        height: 1.35,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Data de Publicação: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: news.publication_date!.formattedDate(),
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                ],

                if (news.research_areas != null &&
                    news.research_areas!.isNotEmpty) ...[
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: textFontSize,
                        color: CustomColors.pine_shadow,
                        height: 1.35,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Áreas de Interesse: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: () {
                            final areas = news.research_areas!
                                .map((e) => e.name ?? '')
                                .where((name) => name.isNotEmpty)
                                .toList();

                            if (areas.length > 3) {
                              return '${areas.take(3).join(', ')}...';
                            }
                            return areas.join(', ');
                          }(),
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 10),

                // Botão "SAIBA MAIS"
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.copper_spice,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'SAIBA MAIS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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


