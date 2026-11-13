import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import '../../../../features/news/models/news.dart';
import '../../../../features/news/models/news_media.dart';
import '../../theme/custom_colors.dart';
import '../../theme/custom_text_styles.dart';
import '../../widgets/custom_row.dart';
import '../tile_card.dart';

class NewsTileDesktopVersion extends StatelessWidget {
  final News news;
  final NewsMedia? newsMedia;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final bool isAdmin;

  const NewsTileDesktopVersion({
    super.key,
    required this.news,
    this.newsMedia,
    this.onTap,
    this.margin,
    this.isAdmin = false,
  });

  /// Altura que as listagens reservam para cada card.
  static const double height = 330.0;
  static const double _coverHeight = 160.0;

  String? get _areasLabel {
    final areas = (news.research_areas ?? [])
        .map((e) => e.name ?? '')
        .where((n) => n.isNotEmpty)
        .toList();
    if (areas.isEmpty) return null;
    if (areas.length > 2) {
      return '${areas.take(2).join(', ')} +${areas.length - 2}';
    }
    return areas.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final areasLabel = _areasLabel;

    return TileCard(
      margin: margin,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TileCover(imageUrl: newsMedia?.media, height: _coverHeight),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title ?? '-',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.cardTitleDesktop.copyWith(
                      color: CustomColors.pine_shadow,
                    ),
                  ),
                  const Spacer(),
                  if (news.publication_date != null)
                    CustomRow(
                      icon: Icons.calendar_today_outlined,
                      text: news.publication_date!.formattedDate(),
                      textColor: CustomColors.midnight_slate,
                      fontSize: 13,
                      iconSize: 15,
                    ),
                  if (areasLabel != null) ...[
                    const SizedBox(height: 6),
                    CustomRow(
                      icon: Icons.sell_outlined,
                      text: areasLabel,
                      textColor: CustomColors.midnight_slate,
                      fontSize: 13,
                      iconSize: 15,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (!isAdmin) const TileReadMore(),
        ],
      ),
    );
  }
}
