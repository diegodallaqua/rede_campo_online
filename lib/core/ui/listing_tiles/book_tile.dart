import 'package:flutter/material.dart';
import '../../../features/books/models/books.dart';
import '../../utils/placeholders.dart';
import '../theme/custom_colors.dart';

class BookTile extends StatelessWidget {
  final Books book;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const BookTile({
    super.key,
    required this.book,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 220.0;
    const double coverHeight = 130.0;
    const double borderRadius = 12.0;
    const double titleFontSize = 14.0;
    const double textFontSize = 12.0;

    final content = Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: CustomColors.honey_cream,
        borderRadius: BorderRadius.circular(borderRadius),
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
              child: book.publisher != null
                  ? Image.network(
                      "assets/images/logo.jpg",
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const CoverPlaceholder(),
                    )
                  : const CoverPlaceholder(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.publication?.title ?? '—',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.pine_shadow,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: textFontSize,
                      color: CustomColors.pine_shadow,
                      height: 1.35,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Editora: ',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: book.publisher,
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: textFontSize,
                      color: CustomColors.pine_shadow,
                      height: 1.35,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Edição: ',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: book.edition,
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
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
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: onTap,
                child: content,
              ),
            ),
    );
  }
}
