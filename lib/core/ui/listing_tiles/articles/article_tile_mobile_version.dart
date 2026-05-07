import 'package:flutter/material.dart';
import '../../../../features/articles/models/articles.dart';
import '../../theme/custom_colors.dart';

class ArticleTileMobileVersion extends StatelessWidget {
  final Articles article;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const ArticleTileMobileVersion({
    super.key,
    required this.article,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width * 0.9;

    final bool isVerySmall = width < 320;

    final double horizontalPadding = isVerySmall ? 14 : 18;
    final double verticalPadding = isVerySmall ? 12 : 14;
    final double titleFontSize = isVerySmall ? 18 : 20;
    final double textFontSize = isVerySmall ? 14 : 16;
    final double borderRadius = 12;

    final content = Container(
      width: width,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: CustomColors.vanilla_haze,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            article.publication!.title!,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w700,
              color: CustomColors.pine_shadow,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          /*RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: textFontSize,
                    color: CustomColors.pine_shadow,
                    height: 1.35,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Áreas de estudo: ',
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
              ),*/
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
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