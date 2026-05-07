import 'package:flutter/material.dart';
import '../../../../features/articles/models/articles.dart';
import '../../theme/custom_colors.dart';

class ArticleTileDesktopVersion extends StatelessWidget {
  final Articles article;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const ArticleTileDesktopVersion({
    super.key,
    required this.article,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 180.0;
    const double cardWidth = 300.0;
    const double horizontalPadding = 16;
    const double verticalPadding = 16;
    const double titleFontSize = 20;
    const double textFontSize = 16;
    const double borderRadius = 12;

    final content = Container(
      width: cardWidth,
      height: cardHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: CustomColors.vanilla_haze,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            article.publication!.title!,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w700,
              color: CustomColors.pine_shadow,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          /*RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: textFontSize,
                color: CustomColors.pine_shadow,
                height: 1.35,
              ),
              children: [
                const TextSpan(
                  text: 'Autores: ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: () {
                    final areas = article.publication!.research_areas!
                        .map((e) => e.name ?? '')
                        .where((name) => name.isNotEmpty)
                        .toList();

                    if (areas.length > 2) {
                      return '${areas.take(2).join(', ')}...';
                    }
                    return areas.join(', ');
                  }(),
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),*/
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
                  text: 'Local de Publicação: ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: article.journal_name,
                  style: const TextStyle(fontWeight: FontWeight.w400),
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