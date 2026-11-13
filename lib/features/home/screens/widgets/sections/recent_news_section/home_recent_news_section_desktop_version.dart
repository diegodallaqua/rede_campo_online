import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../app/router.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/section_title.dart';
import '../../../../../news/stores/news_store.dart';
import '../../listing/recent_news/recent_news_list_widget_desktop_version.dart';

class HomeRecentNewsSectionDesktopVersion extends StatelessWidget {
  final NewsStore newsStore;

  const HomeRecentNewsSectionDesktopVersion(
      {super.key, required this.newsStore});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: SectionTitle(
                  title: 'Notícias Recentes',
                  color: CustomColors.fresh_sprout,
                  trailing: SectionTitleAction(
                    color: CustomColors.concrete_mist,
                    onTap: () => context.go(AppRoutes.news),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              RecentNewsListWidgetDesktopVersion(newsStore: newsStore),
            ],
          ),
        ),
      ),
    );
  }
}
