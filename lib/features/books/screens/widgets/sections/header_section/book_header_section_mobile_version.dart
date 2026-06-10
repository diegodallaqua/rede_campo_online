import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/ui/listing_tiles/research_areas/research_area_tile.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/books.dart';

class BookHeaderSectionMobileVersion extends StatelessWidget {
  final Books book;

  const BookHeaderSectionMobileVersion({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.vanilla_haze,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            book.publication?.title ?? '—',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: CustomColors.copper_spice,
              fontFamily: 'RobotoSlab',
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          if (book.cover_photo != null && book.cover_photo!.isNotEmpty) ...[
            const SizedBox(height: 20),
            MouseRegion(
              cursor: (book.book_url != null && book.book_url!.isNotEmpty)
                  ? SystemMouseCursors.click
                  : MouseCursor.defer,
              child: GestureDetector(
                onTap: (book.book_url != null && book.book_url!.isNotEmpty)
                    ? () => launchUrl(
                          Uri.parse(book.book_url!),
                          mode: LaunchMode.externalApplication,
                        )
                    : null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    book.cover_photo!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (book.publisher != null && book.publisher!.isNotEmpty) ...[
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        color: CustomColors.pine_shadow,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Editora: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: book.publisher),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (book.edition != null && book.edition!.isNotEmpty) ...[
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        color: CustomColors.pine_shadow,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Edição: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: book.edition),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (book.isbn != null && book.isbn!.isNotEmpty) ...[
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        color: CustomColors.pine_shadow,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text: 'ISBN: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: book.isbn),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (book.cover_photo == null &&
                    book.book_url != null &&
                    book.book_url!.isNotEmpty) ...[
                  GestureDetector(
                    onTap: () => launchUrl(Uri.parse(book.book_url!)),
                    child: RichText(
                      maxLines: 2,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: CustomColors.pine_shadow,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Link: ',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: book.book_url,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (book.publication?.publication_date != null)
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        color: CustomColors.pine_shadow,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Publicado em: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                            text: book.publication?.publication_date
                                ?.formattedDate()),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (book.publication?.research_areas != null &&
              book.publication!.research_areas!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: book.publication!.research_areas!
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
