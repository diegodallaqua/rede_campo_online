import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/ui/listing_tiles/research_areas/research_area_tile.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/custom_row.dart';
import '../../../../models/books.dart';

class BookHeaderSectionDesktopVersion extends StatelessWidget {
  final Books book;

  const BookHeaderSectionDesktopVersion({super.key, required this.book});

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
                        'LIVRO',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.copper_spice,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        book.publication?.title ?? '-',
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
                      if (book.publication?.abstract != null &&
                          book.publication!.abstract!.isNotEmpty) ...[
                        const SizedBox(height: 28),
                        Text(
                          book.publication!.abstract!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: CustomColors.pine_shadow,
                            height: 1.8,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                      if (book.publication?.research_areas != null &&
                          book.publication!.research_areas!.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: book.publication!.research_areas!
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
                      if (book.cover_photo != null &&
                          book.cover_photo!.isNotEmpty) ...[
                        _BookCover(url: book.cover_photo!),
                        const SizedBox(height: 16),
                      ],
                      _BookMetadataCard(
                        book: book,
                      ),
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

class _BookCover extends StatelessWidget {
  final String url;

  const _BookCover({required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _BookMetadataCard extends StatelessWidget {
  final Books book;

  const _BookMetadataCard({
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      if (book.publisher!.isNotEmpty)
        CustomRow(
          icon: Icons.business_outlined,
          text: 'Editora: ${book.publisher}',
        ),
      if (book.edition!.isNotEmpty)
        CustomRow(
          icon: Icons.layers_outlined,
          text: 'Edição: ${book.edition}',
        ),
      if (book.isbn != null && book.isbn!.isNotEmpty)
        CustomRow(
          icon: Icons.tag_outlined,
          text: 'ISBN: ${book.isbn}',
        ),
      if (book.book_url != null && book.book_url!.isNotEmpty)
        InkWell(
          onTap: () => launchUrl(Uri.parse(book.book_url!)),
          child: CustomRow(
            icon: Icons.link_outlined,
            text: book.book_url!,
          ),
        ),
      if (book.publication?.publication_date != null)
        CustomRow(
          icon: Icons.calendar_today_outlined,
          text:
              'Publicado em: ${book.publication?.publication_date?.formattedDate()}',
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
