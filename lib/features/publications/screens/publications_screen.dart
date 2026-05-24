import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/layout/footer.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/core/utils/stores/filter_search_store.dart';
import 'package:rede_campo_online/features/articles/stores/articles_store.dart';
import 'package:rede_campo_online/features/book_chapters/stores/book_chapters_store.dart';
import 'package:rede_campo_online/features/books/stores/books_store.dart';
import 'package:rede_campo_online/features/technical_reports/stores/technical_reports_store.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../core/ui/layout/app_scaffold.dart';
import '../../../core/ui/theme/custom_colors.dart';
import 'widgets/sections/header_section/publications_header_section_mobile_version.dart';
import 'widgets/sections/articles_section/publications_articles_section_mobile_version.dart';
import 'widgets/sections/technical_reports_section/publications_technical_reports_section_mobile_version.dart';
import 'widgets/sections/books_section/publications_books_section_mobile_version.dart';
import 'widgets/sections/book_chapters_section/publications_book_chapters_section_mobile_version.dart';

class PublicationsScreen extends StatefulWidget {
  const PublicationsScreen({super.key});

  @override
  State<PublicationsScreen> createState() => _PublicationsScreenState();
}

class _PublicationsScreenState extends State<PublicationsScreen> {
  final ArticlesStore _articlesStore = ArticlesStore(pageSize: 4);
  final TechnicalReportsStore _technicalReportsStore =
      TechnicalReportsStore(pageSize: 4);
  final BooksStore _booksStore = BooksStore(pageSize: 3);
  final BookChaptersStore _bookChaptersStore = BookChaptersStore(pageSize: 3);
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    final filter = FilterSearchStore()..setSearch(value);
    _articlesStore.setFilter(filter);
    _technicalReportsStore.setFilter(filter);
    _booksStore.setFilter(filter);
    _bookChaptersStore.setFilter(filter);
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
              const PublicationsHeaderSectionMobileVersion(),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                      child: CustomSearchBar(
                        controller: _searchController,
                        onSubmitted: _onSearch,
                      ),
                    ),
                    PublicationsArticlesSectionMobileVersion(
                      articlesStore: _articlesStore,
                    ),
                    PublicationsTechnicalReportsSectionMobileVersion(
                      technicalReportsStore: _technicalReportsStore,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              PublicationsBooksSectionMobileVersion(
                booksStore: _booksStore,
              ),
              PublicationsBookChaptersSectionMobileVersion(
                bookChaptersStore: _bookChaptersStore,
              ),
              const Footer(),
            ],
          ),
        ),
        child: const SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Desktop version — a implementar
            ],
          ),
        ),
      ),
    );
  }
}
