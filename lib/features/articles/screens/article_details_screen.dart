import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/ui/layout/app_scaffold.dart';
import '../../../core/ui/layout/footer.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../models/articles.dart';
import '../stores/article_details_store.dart';
import 'widgets/sections/authors_section/article_authors_section_desktop_version.dart';
import 'widgets/sections/authors_section/article_authors_section_mobile_version.dart';
import 'widgets/sections/content_section/article_content_section_desktop_version.dart';
import 'widgets/sections/content_section/article_content_section_mobile_version.dart';
import 'widgets/sections/header_section/article_header_section_desktop_version.dart';
import 'widgets/sections/header_section/article_header_section_mobile_version.dart';

class ArticleDetailsScreen extends StatefulWidget {
  final Articles article;

  const ArticleDetailsScreen({super.key, required this.article});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  late final ArticleDetailsStore articleDetailsStore;

  @override
  void initState() {
    super.initState();
    articleDetailsStore = ArticleDetailsStore();
    articleDetailsStore
        .fetchTranslation(widget.article.publication?.abstract ?? '');
  }

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
              ArticleHeaderSectionMobileVersion(article: widget.article),
              ArticleContentSectionMobileVersion(
                article: widget.article,
                store: articleDetailsStore,
              ),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child:
                    ArticleAuthorsSectionMobileVersion(article: widget.article),
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
              ArticleHeaderSectionDesktopVersion(article: widget.article),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ArticleContentSectionDesktopVersion(
                      article: widget.article,
                      store: articleDetailsStore,
                    ),
                    ArticleAuthorsSectionDesktopVersion(
                        article: widget.article),
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
