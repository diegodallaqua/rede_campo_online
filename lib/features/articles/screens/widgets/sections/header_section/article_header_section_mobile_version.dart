import 'package:flutter/material.dart';
import '../../../../../../core/utils/external_links.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/articles.dart';

class ArticleHeaderSectionMobileVersion extends StatelessWidget {
  final Articles article;

  const ArticleHeaderSectionMobileVersion({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final title = article.publication?.title ?? '-';
    final doi = article.publication?.doi ?? '';

    return Container(
      color: CustomColors.vanilla_haze,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: CustomColors.copper_spice,
              fontFamily: 'RobotoSlab',
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          if (doi.isNotEmpty) ...[
            const SizedBox(height: 12),
            _DoiLink(doi: doi),
          ],
        ],
      ),
    );
  }
}

class _DoiLink extends StatelessWidget {
  final String doi;

  const _DoiLink({required this.doi});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openExternalUrl(doiUrl(doi)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DOI: ',
            style: TextStyle(
              fontSize: 13,
              color: CustomColors.pine_shadow,
            ),
          ),
          Flexible(
            child: Text(
              doi,
              style: const TextStyle(
                fontSize: 13,
                color: CustomColors.fresh_sprout,
                decoration: TextDecoration.underline,
                decorationColor: CustomColors.fresh_sprout,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
