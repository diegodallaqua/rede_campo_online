import 'package:flutter/material.dart';
import '../../../../features/articles/models/articles.dart';
import '../../theme/custom_colors.dart';
import '../../widgets/custom_chip.dart';

class ArticleTileMobileVersion extends StatelessWidget {
  final Articles article;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const ArticleTileMobileVersion({
    super.key,
    required this.article,
    this.onTap,
    this.margin,
  });

  static const double _height = 118.0;
  static const double _accentWidth = 5.0;
  static const double _borderRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    final pub = article.publication;
    final title = pub?.title ?? '-';
    final journal = article.journal_name ?? '';
    final volume = article.volume ?? '';
    final issue = article.issue ?? '';
    final pages = article.pages ?? '';
    final date = pub?.publication_date;
    final year = date != null ? date.year.toString() : '';

    final volumeLabel = [
      if (volume.isNotEmpty) 'vol. $volume',
      if (issue.isNotEmpty) 'n. $issue',
    ].join('  ');

    final pagesLabel = pages.isNotEmpty ? 'pp. $pages' : '';

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
            Container(
              width: _accentWidth,
              color: CustomColors.fresh_sprout,
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
                    const Spacer(),
                    const Divider(
                      height: 1,
                      thickness: 0.8,
                      color: CustomColors.concrete_mist,
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(
                          Icons.menu_book_outlined,
                          size: 12,
                          color: CustomColors.pine_shadow,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            journal.isNotEmpty ? journal : '-',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: CustomColors.pine_shadow,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (volumeLabel.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          CustomChip(label: volumeLabel),
                        ],
                      ],
                    ),
                    if (year.isNotEmpty || pagesLabel.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 11,
                            color: CustomColors.pine_shadow,
                          ),
                          const SizedBox(width: 5),
                          if (year.isNotEmpty)
                            Text(
                              year,
                              style: const TextStyle(
                                fontSize: 11,
                                color: CustomColors.pine_shadow,
                                height: 1.3,
                              ),
                            ),
                          if (pagesLabel.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Text(
                              '·  $pagesLabel',
                              style: TextStyle(
                                fontSize: 11,
                                color:
                                    CustomColors.pine_shadow.withOpacity(0.65),
                                height: 1.3,
                              ),
                            ),
                          ],
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
