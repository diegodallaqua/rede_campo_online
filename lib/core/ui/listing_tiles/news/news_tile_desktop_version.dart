import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import '../../../../features/news/models/news.dart';
import '../../../../features/news/models/news_media.dart';
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
    const double coverHeight = 180.0;
    const double borderRadius = 12.0;

    final content = Container(
      decoration: BoxDecoration(
        color: CustomColors.vanilla_haze,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: CustomColors.midnight_slate.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
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
              child: newsMedia != null &&
                      newsMedia!.media != null &&
                      newsMedia!.media!.isNotEmpty
                  ? Image.network(
                      newsMedia!.media!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ImagePlaceholder(),
                    )
                  : const ImagePlaceholder(),
            ),
          ),
          Container(height: 1, color: CustomColors.pine_shadow),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title ?? '—',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.pine_shadow,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                if (news.publication_date != null) ...[
                  _MetaRow(
                    icon: Icons.calendar_today_outlined,
                    text: news.publication_date!.formattedDate(),
                  ),
                  const SizedBox(height: 5),
                ],
                if (news.research_areas != null &&
                    news.research_areas!.isNotEmpty)
                  _MetaRow(
                    icon: Icons.sell_outlined,
                    text: () {
                      final areas = news.research_areas!
                          .map((e) => e.name ?? '')
                          .where((n) => n.isNotEmpty)
                          .toList();
                      if (areas.length > 2) {
                        return '${areas.take(2).join(', ')} +${areas.length - 2}';
                      }
                      return areas.join(', ');
                    }(),
                  ),
                const SizedBox(height: 12),
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
                        fontSize: 12,
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
              borderRadius: BorderRadius.circular(borderRadius),
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: onTap,
                child: content,
              ),
            ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: CustomColors.copper_spice),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: CustomColors.pine_shadow,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
