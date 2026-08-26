import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';

import '../../../../../../core/ui/listing_tiles/research_areas/research_area_tile.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/custom_row.dart';
import '../../../../models/book_chapters.dart';

class BookChapterHeaderSectionDesktopVersion extends StatelessWidget {
  final BookChapters bookChapter;

  const BookChapterHeaderSectionDesktopVersion({
    super.key,
    required this.bookChapter,
  });

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
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CAPÍTULO DE LIVRO',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.copper_spice,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        bookChapter.publication?.title ?? '-',
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          color: CustomColors.midnight_slate,
                          fontFamily: 'RobotoSlab',
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 56,
                        height: 4,
                        decoration: BoxDecoration(
                          color: CustomColors.copper_spice,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      if (bookChapter.publication?.abstract != null &&
                          bookChapter.publication!.abstract!.isNotEmpty) ...[
                        const SizedBox(height: 28),
                        Text(
                          bookChapter.publication!.abstract!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: CustomColors.pine_shadow,
                            height: 1.8,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                      if (bookChapter.publication?.research_areas != null &&
                          bookChapter
                              .publication!.research_areas!.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: bookChapter.publication!.research_areas!
                              .map((area) => ResearchAreaTile(
                                    researchArea: area,
                                    green: true,
                                  ))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 64),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ChapterNumberBadge(
                        chapterNumber: bookChapter.chapter_number ?? 0,
                      ),
                      const SizedBox(height: 16),
                      _BookChapterMetadataCard(bookChapter: bookChapter),
                    ],
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

class _ChapterNumberBadge extends StatelessWidget {
  final num chapterNumber;

  const _ChapterNumberBadge({required this.chapterNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.copper_spice,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'CAPÍTULO',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            chapterNumber.toString(),
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontFamily: 'RobotoSlab',
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookChapterMetadataCard extends StatelessWidget {
  final BookChapters bookChapter;

  const _BookChapterMetadataCard({required this.bookChapter});

  @override
  Widget build(BuildContext context) {
    final rows = <CustomRow>[
      if (bookChapter.book_name != null && bookChapter.book_name!.isNotEmpty)
        CustomRow(
          icon: Icons.menu_book_outlined,
          text: 'Livro: ${bookChapter.book_name}',
        ),
      if (bookChapter.publication?.publication_date != null)
        CustomRow(
          icon: Icons.calendar_today_outlined,
          text:
              'Publicado em: ${bookChapter.publication?.publication_date?.formattedDate()}',
        ),
    ];

    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CustomColors.copper_spice.withOpacity(0.2),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'INFORMAÇÕES',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: CustomColors.copper_spice,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i < rows.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
