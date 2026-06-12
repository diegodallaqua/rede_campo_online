import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/ui/sections/abstract_section.dart';
import '../../../core/ui/sections/authors_section.dart';
import '../../../core/ui/widgets/layout/app_scaffold.dart';
import '../../../core/ui/widgets/layout/footer.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/stores/translation_store.dart';
import '../models/articles.dart';
import 'widgets/sections/header_section/article_header_section_desktop_version.dart';
import 'widgets/sections/header_section/article_header_section_mobile_version.dart';

class ArticleDetailsScreen extends StatefulWidget {
  final Articles article;

  const ArticleDetailsScreen({super.key, required this.article});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  late final TranslationStore translationStore;

  static const _authorsTitle = 'Autores do Artigo';
  static const _authorsEmptyMessage = 'Nenhum autor vinculado a este artigo.';

  @override
  void initState() {
    super.initState();
    translationStore = TranslationStore();
    translationStore
        .fetchTranslation(widget.article.publication?.abstract ?? '');
  }

  String get _publishedLabel {
    final parts = <String>[];
    final journal = widget.article.journal_name ?? '';
    final volume = widget.article.volume ?? '';
    final date = widget.article.publication?.publication_date;
    if (journal.isNotEmpty) parts.add(journal);
    if (volume.isNotEmpty) parts.add('v.$volume');
    if (date != null && date.formattedDate().isNotEmpty) {
      parts.add(date.formattedDate());
    }
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final abstractText = widget.article.publication?.abstract ?? '';
    final contributors = widget.article.publication?.contributors ?? [];

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
              AbstractSectionMobileVersion(
                abstractText: abstractText,
                store: translationStore,
                publishedLabel: _publishedLabel,
                researchAreas: widget.article.publication?.research_areas ?? [],
              ),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: AuthorsSectionMobileVersion(
                  title: _authorsTitle,
                  emptyMessage: _authorsEmptyMessage,
                  contributors: contributors,
                ),
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
                    AbstractSectionDesktopVersion(
                      abstractText: abstractText,
                      store: translationStore,
                    ),
                    AuthorsSectionDesktopVersion(
                      title: _authorsTitle,
                      emptyMessage: _authorsEmptyMessage,
                      contributors: contributors,
                    ),
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
