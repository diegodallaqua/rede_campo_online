import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/ui/widgets/layout/app_scaffold.dart';
import '../../../core/ui/widgets/layout/footer.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../models/news.dart';
import '../stores/news_detail_store.dart';
import 'widgets/sections/news_detail_author_section/news_detail_author_section_desktop_version.dart';
import 'widgets/sections/news_detail_author_section/news_detail_author_section_mobile_version.dart';
import 'widgets/sections/news_detail_content_section/news_detail_content_section_desktop_version.dart';
import 'widgets/sections/news_detail_content_section/news_detail_content_section_mobile_version.dart';
import 'widgets/sections/news_detail_header_section/news_detail_header_section_desktop_version.dart';
import 'widgets/sections/news_detail_header_section/news_detail_header_section_mobile_version.dart';
import 'widgets/sections/news_detail_media_carousel_section/news_detail_media_carousel_section_mobile_version.dart';

class NewsDetailsScreen extends StatelessWidget {
  final News news;

  const NewsDetailsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final newsDetailStore = NewsDetailStore(newsId: news.id!);

    return AppScaffold(
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NewsDetailHeaderSectionMobileVersion(news: news),
              NewsDetailMediaCarouselSectionMobileVersion(
                  newsDetailStore: newsDetailStore),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    NewsDetailContentSectionMobileVersion(news: news),
                  ],
                ),
              ),
              NewsDetailAuthorSectionMobileVersion(news: news),
              const SizedBox(height: 16),
              const Footer(),
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NewsDetailHeaderSectionDesktopVersion(
                news: news,
                newsDetailStore: newsDetailStore,
              ),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    NewsDetailContentSectionDesktopVersion(news: news),
                  ],
                ),
              ),
              NewsDetailAuthorSectionDesktopVersion(news: news),
              const SizedBox(height: 16),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
