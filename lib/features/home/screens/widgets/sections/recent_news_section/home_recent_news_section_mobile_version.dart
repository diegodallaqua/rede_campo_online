import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../news/stores/news_store.dart';
import '../../listing/recent_news/recent_news_list_widget_mobile_version.dart';

class HomeRecentNewsSectionMobileVersion extends StatelessWidget {
  final NewsStore newsStore;

  const HomeRecentNewsSectionMobileVersion(
      {super.key, required this.newsStore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Notícias',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: CustomColors.fresh_sprout,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RecentNewsListWidgetMobileVersion(
              newsStore: newsStore,
              visibleCount: 3,
              totalCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}
