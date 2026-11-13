import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import '../../../../features/news/models/news.dart';
import '../../../../features/news/models/news_media.dart';
import '../../theme/custom_colors.dart';
import '../../theme/custom_text_styles.dart';
import '../../widgets/custom_row.dart';
import '../tile_card.dart';

class NewsTileMobileVersion extends StatelessWidget {
  final News news;
  final NewsMedia? newsMedia;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final bool isAdmin;

  const NewsTileMobileVersion({
    super.key,
    required this.news,
    this.newsMedia,
    this.onTap,
    this.margin,
    this.isAdmin = false,
  });

  /// Altura fixa do card, usada também pelas listagens.
  static const double height = 136.0;
  static const double _imageWidth = 96.0;

  String? get _areasLabel {
    final areas = (news.research_areas ?? [])
        .map((e) => e.name ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
    if (areas.isEmpty) return null;
    if (areas.length > 2) {
      return '${areas.take(2).join(', ')} +${areas.length - 2}';
    }
    return areas.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final description = news.description?.trim();
    final date = news.publication_date;
    final areasLabel = _areasLabel;

    return TileCard(
      margin: margin,
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: _imageWidth,
              child: TileCover(imageUrl: newsMedia?.media, height: height),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.cardTitleMobile.copyWith(
                        color: CustomColors.pine_shadow,
                      ),
                    ),
                    if (description != null && description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.meta.copyWith(
                          color: CustomColors.pine_shadow.withOpacity(0.8),
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (areasLabel != null)
                      CustomRow(
                        icon: Icons.sell_outlined,
                        text: areasLabel,
                        textColor: CustomColors.midnight_slate,
                        fontSize: 13,
                        iconSize: 14,
                      ),
                    if (date != null) ...[
                      const SizedBox(height: 4),
                      CustomRow(
                        icon: Icons.calendar_today_outlined,
                        text: date.formattedDate(),
                        textColor: CustomColors.midnight_slate,
                        fontSize: 13,
                        iconSize: 14,
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
  }
}
