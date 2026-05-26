import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/articles/stores/articles_store.dart';
import '../../listing/publications_articles_list_widget_desktop_version.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';

class PublicationsArticlesSectionDesktopVersion extends StatefulWidget {
  final ArticlesStore articlesStore;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const PublicationsArticlesSectionDesktopVersion({
    super.key,
    required this.articlesStore,
    required this.searchController,
    required this.onSearch,
  });

  @override
  State<PublicationsArticlesSectionDesktopVersion> createState() =>
      _PublicationsArticlesSectionDesktopVersionState();
}

class _PublicationsArticlesSectionDesktopVersionState
    extends State<PublicationsArticlesSectionDesktopVersion> {
  int _maxDiscoveredPage = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Artigos',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: CustomColors.fresh_sprout,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 64,
                          height: 3,
                          decoration: BoxDecoration(
                            color: CustomColors.fresh_sprout,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: CustomSearchBar(
                        controller: widget.searchController,
                        onSubmitted: widget.onSearch,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PublicationsArticlesListWidgetDesktopVersion(
                articlesStore: widget.articlesStore,
                maxDiscoveredPage: _maxDiscoveredPage,
                onPageDiscovered: (newMax) {
                  if (newMax != _maxDiscoveredPage) {
                    setState(() => _maxDiscoveredPage = newMax);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
