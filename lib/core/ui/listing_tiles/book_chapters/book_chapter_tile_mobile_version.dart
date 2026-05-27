import 'package:flutter/material.dart';
import '../../../../features/book_chapters/models/book_chapters.dart';
import '../../theme/custom_colors.dart';
import '../../widgets/custom_chip.dart';
import '../../widgets/custom_row.dart';

class BookChapterTileMobileVersion extends StatelessWidget {
  final BookChapters bookChapter;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const BookChapterTileMobileVersion({
    super.key,
    required this.bookChapter,
    this.onTap,
    this.margin,
  });

  static const double _height = 118.0;
  static const double _accentWidth = 5.0;
  static const double _borderRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    final pub = bookChapter.publication;
    final title = pub?.title ?? '—';
    final bookName = bookChapter.book_name ?? '';
    final chapterNumber = bookChapter.chapter_number;
    final date = pub?.publication_date;
    final year = date != null ? date.year.toString() : '';

    final chapterLabel = (chapterNumber != null && chapterNumber > 0)
        ? 'Capítulo ${chapterNumber.toInt()}'
        : '';

    final card = SizedBox(
      height: _height,
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.honey_cream,
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
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
              color: CustomColors.copper_spice,
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
                    Divider(
                      height: 1,
                      thickness: 0.8,
                      color: CustomColors.copper_spice.withOpacity(0.3),
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
                            bookName.isNotEmpty ? bookName : '—',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: CustomColors.pine_shadow,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (chapterLabel.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          CustomChip(label: chapterLabel),
                        ],
                      ],
                    ),
                    if (year.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      CustomRow(
                        icon: Icons.calendar_today_outlined,
                        iconColor: CustomColors.pine_shadow,
                        text: year,
                        fontSize: 11,
                        iconSize: 11,
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
