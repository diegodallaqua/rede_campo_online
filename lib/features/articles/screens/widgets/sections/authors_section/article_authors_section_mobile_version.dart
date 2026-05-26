import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/articles.dart';
import '../../listing/authors/article_authors_list_widget_mobile_version.dart';

class ArticleAuthorsSectionMobileVersion extends StatelessWidget {
  final Articles article;

  const ArticleAuthorsSectionMobileVersion({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final contributors = article.publication?.contributors ?? [];

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Autores do Artigo',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ArticleAuthorsListWidgetMobileVersion(contributors: contributors),
        ],
      ),
    );
  }
}
