import 'package:flutter/material.dart';
import '../../../../features/books/models/books.dart';
import '../../../utils/placeholders.dart';
import '../../theme/custom_colors.dart';

class BookTileDesktopVersion extends StatelessWidget {
  final Books book;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const BookTileDesktopVersion({
    super.key,
    required this.book,
    this.onTap,
    this.margin,
  });

  static const double _coverHeight = 140.0;
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

    final card = Container(
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: _coverHeight,
            child: _buildCover(book.cover_photo),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 38,
                    child: Text(
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
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    height: 1,
                    thickness: 0.8,
                    color: CustomColors.concrete_mist,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.business_outlined,
                        size: 13,
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
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: CustomColors.pine_shadow,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        year.isNotEmpty ? year : '—',
                        style: const TextStyle(
                          fontSize: 12,
                          color: CustomColors.pine_shadow,
                          height: 1.3,
                        ),
                      ),
                      if (edition.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '·  $edition',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: CustomColors.pine_shadow.withOpacity(0.65),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Spacer(),
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
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
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
