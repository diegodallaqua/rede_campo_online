import 'package:flutter/material.dart';
import 'package:rede_campo_online/features/articles/stores/articles_store.dart';
import '../../listing/articles/publications_articles_list_widget_mobile_version.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';

class PublicationsArticlesSectionMobileVersion extends StatefulWidget {
  final ArticlesStore articlesStore;

  const PublicationsArticlesSectionMobileVersion({
    super.key,
    required this.articlesStore,
  });

  @override
  State<PublicationsArticlesSectionMobileVersion> createState() =>
      _PublicationsArticlesSectionMobileVersionState();
}

class _PublicationsArticlesSectionMobileVersionState
    extends State<PublicationsArticlesSectionMobileVersion> {
  int _maxDiscoveredPage = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Artigos',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 16),
          PublicationsArticlesListWidgetMobileVersion(
            articlesStore: widget.articlesStore,
            maxDiscoveredPage: _maxDiscoveredPage,
            onPageDiscovered: (newMax) {
              if (newMax > _maxDiscoveredPage) {
                setState(() => _maxDiscoveredPage = newMax);
              }
            },
          ),
        ],
      ),
    );
  }
}
