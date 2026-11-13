import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/router.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/section_title.dart';
import '../../../../../news/stores/news_store.dart';
import '../../listing/recent_news/recent_news_list_widget_mobile_version.dart';

class HomeRecentNewsSectionMobileVersion extends StatelessWidget {
  final NewsStore newsStore;

  const HomeRecentNewsSectionMobileVersion(
      {super.key, required this.newsStore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionTitle.mobile(
              title: 'Notícias',
              color: CustomColors.fresh_sprout,
              trailing: SectionTitleAction(
                color: CustomColors.concrete_mist,
                onTap: () => context.go(AppRoutes.news),
              ),
            ),
          ),
          const SizedBox(height: 16),
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
