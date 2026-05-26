import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/ui/layout/app_scaffold.dart';
import '../../../core/ui/layout/footer.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../models/articles.dart';
import 'widgets/sections/article_authors_section/article_authors_section_desktop_version.dart';
import 'widgets/sections/article_authors_section/article_authors_section_mobile_version.dart';
import 'widgets/sections/article_content_section/article_content_section_desktop_version.dart';
import 'widgets/sections/article_content_section/article_content_section_mobile_version.dart';
import 'widgets/sections/article_header_section/article_header_section_desktop_version.dart';
import 'widgets/sections/article_header_section/article_header_section_mobile_version.dart';

class ArticleDetailsScreen extends StatelessWidget {
  final Articles article;

  const ArticleDetailsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ArticleHeaderSectionMobileVersion(article: article),
              ArticleContentSectionMobileVersion(article: article),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: ArticleAuthorsSectionMobileVersion(article: article),
              ),
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
              ArticleHeaderSectionDesktopVersion(article: article),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ArticleContentSectionDesktopVersion(article: article),
                    ArticleAuthorsSectionDesktopVersion(article: article),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
