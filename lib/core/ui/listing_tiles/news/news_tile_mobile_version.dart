import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import '../../../../features/news/models/news.dart';
import '../../../../features/news/models/news_media.dart';
import '../../../utils/placeholders.dart';
import '../../theme/custom_colors.dart';

class NewsTileMobileVersion extends StatelessWidget {
  final News news;
  final NewsMedia? newsMedia;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const NewsTileMobileVersion({
    super.key,
    required this.news,
    this.newsMedia,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.sizeOf(context).width * 0.9;
    const double imageSize = 90.0;
    const double borderRadius = 12.0;
    const double titleFontSize = 13.0;
    const double textFontSize = 11.0;

    final content = Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: CustomColors.vanilla_haze,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                bottomLeft: Radius.circular(borderRadius),
              ),
              child: SizedBox(
                width: imageSize,
                height: imageSize,
                child: newsMedia != null && newsMedia!.media != null && newsMedia!.media!.isNotEmpty
                    ? Image.network(
                  newsMedia!.media!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ImagePlaceholder(),
                )
                    : const ImagePlaceholder(),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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

                    const SizedBox(height: 5),

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
                  ],
                ),
              ),
            ),
          ],
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