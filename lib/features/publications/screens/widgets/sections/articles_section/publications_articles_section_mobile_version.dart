import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/articles/stores/articles_store.dart';
import '../../listing/articles/publications_articles_list_widget_mobile_version.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';

class PublicationsArticlesSectionMobileVersion extends StatefulWidget {
  final ArticlesStore articlesStore;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const PublicationsArticlesSectionMobileVersion({
    super.key,
    required this.articlesStore,
    required this.searchController,
    required this.onSearch,
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
          CustomSearchBar(
            controller: widget.searchController,
            onSubmitted: widget.onSearch,
            hintText: 'Pesquisar artigos',
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
