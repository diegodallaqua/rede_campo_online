import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/news/stores/news_store.dart';
import '../../listing/news/news_list_widget_desktop_version.dart';

class NewsListSectionDesktopVersion extends StatefulWidget {
  final NewsStore newsStore;

  const NewsListSectionDesktopVersion({super.key, required this.newsStore});

  @override
  State<NewsListSectionDesktopVersion> createState() =>
      _NewsListSectionDesktopVersionState();
}

class _NewsListSectionDesktopVersionState
    extends State<NewsListSectionDesktopVersion> {
  final TextEditingController _searchController = TextEditingController();
  int _maxDiscoveredPage = 1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    widget.newsStore.filterStore.setSearch(value);
    widget.newsStore.refreshData();
    setState(() => _maxDiscoveredPage = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 32),
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
                          'Notícias',
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
                        controller: _searchController,
                        onSubmitted: _onSearch,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              NewsListWidgetDesktopVersion(
                newsStore: widget.newsStore,
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
