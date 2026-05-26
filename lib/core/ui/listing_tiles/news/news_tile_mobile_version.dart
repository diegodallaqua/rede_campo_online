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

  static const double _height = 130.0;
  static const double _imageWidth = 90.0;
  static const double _borderRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    final title = news.title ?? '—';
    final description = news.description?.trim();
    final date = news.publication_date;

    final areas = (news.research_areas ?? [])
        .map((e) => e.name ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    final areasLabel = areas.isEmpty
        ? null
        : areas.length > 2
            ? '${areas.take(2).join(', ')}  +${areas.length - 2}'
            : areas.join(', ');

    final hasImage = newsMedia?.media != null && newsMedia!.media!.isNotEmpty;

    final card = SizedBox(
      height: _height,
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.vanilla_haze,
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: _imageWidth,
              child: hasImage
                  ? Image.network(
                      newsMedia!.media!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ImagePlaceholder(),
                    )
                  : const ImagePlaceholder(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: CustomColors.pine_shadow,
                        height: 1.35,
                      ),
                    ),
                    if (description != null && description.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: CustomColors.pine_shadow.withOpacity(0.7),
                          height: 1.3,
                        ),
                      ),
                    ],
                    const Spacer(),
                    const Divider(
                      height: 1,
                      thickness: 0.8,
                      color: CustomColors.concrete_mist,
                    ),
                    const SizedBox(height: 7),
                    if (areasLabel != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.sell_outlined,
                            size: 12,
                            color: CustomColors.pine_shadow,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              areasLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: CustomColors.pine_shadow,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (date != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 11,
                            color: CustomColors.pine_shadow,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            date.formattedDate(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: CustomColors.pine_shadow,
                              height: 1.3,
                            ),
                          ),
                        ],
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
          ? card
          : Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(_borderRadius),
                onTap: onTap,
                child: card,
              ),
            ),
    );
  }
}
