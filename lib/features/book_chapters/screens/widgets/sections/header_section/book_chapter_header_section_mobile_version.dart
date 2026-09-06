import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';

import '../../../../../../core/ui/listing_tiles/research_areas/research_area_tile.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/book_chapters.dart';

class BookChapterHeaderSectionMobileVersion extends StatelessWidget {
  final BookChapters bookChapter;

  const BookChapterHeaderSectionMobileVersion({
    super.key,
    required this.bookChapter,
  });

  @override
  Widget build(BuildContext context) {
    // Nome e ISBN do livro vinculado têm precedência sobre os do próprio
    // capítulo.
    final bookName = bookChapter.displayBookName ?? '';
    final isbn = bookChapter.displayIsbn ?? '';
    final pageRange = bookChapter.pageRange;
    final publicationDate = bookChapter.publication?.publication_date;

    final infoLines = <Widget>[
      if (bookName.isNotEmpty) _InfoLine(label: 'Livro', value: bookName),
      if (isbn.isNotEmpty) _InfoLine(label: 'ISBN', value: isbn),
      if (pageRange.isNotEmpty) _InfoLine(label: 'Páginas', value: pageRange),
      if (publicationDate != null)
        _InfoLine(
          label: 'Publicado em',
          value: publicationDate.formattedDate(),
        ),
    ];

    return Container(
      color: CustomColors.vanilla_haze,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            bookChapter.publication?.title ?? '-',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: CustomColors.copper_spice,
              fontFamily: 'RobotoSlab',
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: CustomColors.copper_spice,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Capítulo ${bookChapter.chapter_number}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < infoLines.length; i++) ...[
                  infoLines[i],
                  if (i < infoLines.length - 1) const SizedBox(height: 8),
                ],
              ],
            ),
          ),
          if (bookChapter.publication?.research_areas != null &&
              bookChapter.publication!.research_areas!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: bookChapter.publication!.research_areas!
                    .map((area) => ResearchAreaTile(
                          researchArea: area,
                          green: true,
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13,
          color: CustomColors.pine_shadow,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
