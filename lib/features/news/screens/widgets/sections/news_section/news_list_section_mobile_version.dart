import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/news/stores/news_store.dart';
import '../../listing/news/news_list_widget_mobile_version.dart';

class NewsListSectionMobileVersion extends StatefulWidget {
  final NewsStore newsStore;

  const NewsListSectionMobileVersion({
    super.key,
    required this.newsStore,
  });

  @override
  State<NewsListSectionMobileVersion> createState() =>
      _NewsListSectionMobileVersionState();
}

class _NewsListSectionMobileVersionState
    extends State<NewsListSectionMobileVersion> {
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomSearchBar(
            controller: _searchController,
            onSubmitted: _onSearch,
          ),
          const SizedBox(height: 16),
          NewsListWidgetMobileVersion(
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
    );
  }
}
