import 'package:flutter/material.dart';
import '../../../../features/books/models/books.dart';
import '../../../utils/placeholders.dart';
import '../../theme/custom_colors.dart';
import '../../widgets/custom_chip.dart';
import '../../widgets/custom_row.dart';

class BookTileMobileVersion extends StatelessWidget {
  final Books book;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const BookTileMobileVersion({
    super.key,
    required this.book,
    this.onTap,
    this.margin,
  });

  static const double _height = 118.0;
  static const double _coverWidth = 90.0;
  static const double _borderRadius = 12.0;

  Widget _buildCover(String? url) {
    if (url == null || url.isEmpty) return const CoverPlaceholder();
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => const CoverPlaceholder(),
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : const CoverPlaceholder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = book.publication?.title ?? '—';
    final publisher = book.publisher ?? '';
    final edition = book.edition ?? '';
    final date = book.publication?.publication_date;
    final year = date != null ? date.year.toString() : '';

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
            SizedBox(
              width: _coverWidth,
              child: _buildCover(book.cover_photo),
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
                          Icons.business_outlined,
                          size: 12,
                          color: CustomColors.pine_shadow,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            publisher.isNotEmpty ? publisher : '—',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: CustomColors.pine_shadow,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (edition.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          CustomChip(label: edition),
                        ],
                      ],
                    ),
                    if (year.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      CustomRow(
                        icon: Icons.calendar_today_outlined,
                        iconColor: CustomColors.pine_shadow,
                        text: year,
                        iconSize: 11,
                        fontSize: 11,
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
