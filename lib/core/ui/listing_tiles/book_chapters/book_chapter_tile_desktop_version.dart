import 'package:flutter/material.dart';
import '../../../../features/book_chapters/models/book_chapters.dart';
import '../../theme/custom_colors.dart';
import '../../widgets/custom_chip.dart';

class BookChapterTileDesktopVersion extends StatelessWidget {
  final BookChapters bookChapter;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const BookChapterTileDesktopVersion({
    super.key,
    required this.bookChapter,
    this.onTap,
    this.margin,
  });

  static const double _borderRadius = 12.0;
  static const double _accentHeight = 3.0;

  @override
  Widget build(BuildContext context) {
    final pub = bookChapter.publication;
    final title = pub?.title ?? '-';
    final bookName = bookChapter.book_name ?? '';
    final chapterNumber = bookChapter.chapter_number;
    final chapterLabel = (chapterNumber != null && chapterNumber > 0)
        ? 'Cap. ${chapterNumber.toInt()}'
        : '';
    final year = pub?.publication_date?.year.toString() ?? '';
    final areas = pub?.research_areas
            ?.map((e) => e.name ?? '')
            .where((n) => n.isNotEmpty)
            .take(2)
            .toList() ??
        [];

    final content = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: CustomColors.honey_cream,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: _accentHeight,
            color: CustomColors.copper_spice,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.bookmark_outline,
                        size: 12,
                        color: CustomColors.copper_spice,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'CAP. DE LIVRO',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: CustomColors.copper_spice,
                          letterSpacing: 0.6,
                        ),
                      ),
                      if (year.isNotEmpty) ...[
                        const Spacer(),
                        CustomChip(
                          label: year,
                          color: CustomColors.pine_shadow,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
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
                  if (areas.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: areas
                          .map(
                            (area) => Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: CustomChip(
                                label: area,
                                color: CustomColors.copper_spice,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
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
                          bookName.isNotEmpty ? bookName : '-',
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
                        CustomChip(
                          label: chapterLabel,
                          color: CustomColors.copper_spice,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
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
                borderRadius: BorderRadius.circular(_borderRadius),
                onTap: onTap,
                child: content,
              ),
            ),
    );
  }
}
