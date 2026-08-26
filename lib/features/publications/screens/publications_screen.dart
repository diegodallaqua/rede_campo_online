import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/layout/footer.dart';
import 'package:rede_campo_online/core/stores/filter_search_store.dart';
import 'package:rede_campo_online/features/articles/stores/articles_store.dart';
import 'package:rede_campo_online/features/book_chapters/stores/book_chapters_store.dart';
import 'package:rede_campo_online/features/books/stores/books_store.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../core/ui/widgets/layout/app_scaffold.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../../thesis/stores/thesis_store.dart';
import 'widgets/sections/header_section/publications_header_section_mobile_version.dart';
import 'widgets/sections/header_section/publications_header_section_desktop_version.dart';
import 'widgets/sections/articles_section/publications_articles_section_mobile_version.dart';
import 'widgets/sections/articles_section/publications_articles_section_desktop_version.dart';
import 'widgets/sections/thesis_section/publications_thesis_section_mobile_version.dart';
import 'widgets/sections/thesis_section/publications_thesis_section_desktop_version.dart';
import 'widgets/sections/books_section/publications_books_section_mobile_version.dart';
import 'widgets/sections/books_section/publications_books_section_desktop_version.dart';
import 'widgets/sections/book_chapters_section/publications_book_chapters_section_mobile_version.dart';
import 'widgets/sections/book_chapters_section/publications_book_chapters_section_desktop_version.dart';

class PublicationsScreen extends StatefulWidget {
  const PublicationsScreen({super.key});

  @override
  State<PublicationsScreen> createState() => _PublicationsScreenState();
}

class _PublicationsScreenState extends State<PublicationsScreen> {
  // Mobile stores
  final ArticlesStore _articlesStore = ArticlesStore(pageSize: 4);
  final ThesisStore _thesisStore = ThesisStore(pageSize: 4);
  final BooksStore _booksStore = BooksStore(pageSize: 3);
  final BookChaptersStore _bookChaptersStore = BookChaptersStore(pageSize: 3);

  // Mobile search controllers (um por tipo de publicação)
  final TextEditingController _articlesSearchController =
      TextEditingController();
  final TextEditingController _thesisSearchController = TextEditingController();
  final TextEditingController _booksSearchController = TextEditingController();
  final TextEditingController _bookChaptersSearchController =
      TextEditingController();

  // Desktop stores
  final ArticlesStore _articlesStoreDesktop = ArticlesStore(pageSize: 8);
  final ThesisStore _thesisStoreDesktop = ThesisStore(pageSize: 8);
  final BooksStore _booksStoreDesktop = BooksStore(pageSize: 10);
  final BookChaptersStore _bookChaptersStoreDesktop =
      BookChaptersStore(pageSize: 8);

  // Desktop search controllers (um por tipo de publicação)
  final TextEditingController _articlesSearchControllerDesktop =
      TextEditingController();
  final TextEditingController _thesisSearchControllerDesktop =
      TextEditingController();
  final TextEditingController _booksSearchControllerDesktop =
      TextEditingController();
  final TextEditingController _bookChaptersSearchControllerDesktop =
      TextEditingController();

  @override
  void dispose() {
    _articlesSearchController.dispose();
    _thesisSearchController.dispose();
    _booksSearchController.dispose();
    _bookChaptersSearchController.dispose();
    _articlesSearchControllerDesktop.dispose();
    _thesisSearchControllerDesktop.dispose();
    _booksSearchControllerDesktop.dispose();
    _bookChaptersSearchControllerDesktop.dispose();
    super.dispose();
  }

  FilterSearchStore _buildFilter(String value) =>
      FilterSearchStore()..setSearch(value);

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
                    PublicationsArticlesSectionMobileVersion(
                      articlesStore: _articlesStore,
                      searchController: _articlesSearchController,
                      onSearch: (value) =>
                          _articlesStore.setFilter(_buildFilter(value)),
                    ),
                    PublicationsThesisSectionMobileVersion(
                      thesisStore: _thesisStore,
                      searchController: _thesisSearchController,
                      onSearch: (value) =>
                          _thesisStore.setFilter(_buildFilter(value)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              PublicationsBooksSectionMobileVersion(
                booksStore: _booksStore,
                searchController: _booksSearchController,
                onSearch: (value) => _booksStore.setFilter(_buildFilter(value)),
              ),
              PublicationsBookChaptersSectionMobileVersion(
                bookChaptersStore: _bookChaptersStore,
                searchController: _bookChaptersSearchController,
                onSearch: (value) =>
                    _bookChaptersStore.setFilter(_buildFilter(value)),
              ),
              const Footer(),
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PublicationsHeaderSectionDesktopVersion(),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PublicationsArticlesSectionDesktopVersion(
                      articlesStore: _articlesStoreDesktop,
                      searchController: _articlesSearchControllerDesktop,
                      onSearch: (value) =>
                          _articlesStoreDesktop.setFilter(_buildFilter(value)),
                    ),
                    PublicationsThesisSectionDesktopVersion(
                      thesisStore: _thesisStoreDesktop,
                      searchController: _thesisSearchControllerDesktop,
                      onSearch: (value) =>
                          _thesisStoreDesktop.setFilter(_buildFilter(value)),
                    ),
                  ],
                ),
              ),
              PublicationsBooksSectionDesktopVersion(
                booksStore: _booksStoreDesktop,
                searchController: _booksSearchControllerDesktop,
                onSearch: (value) =>
                    _booksStoreDesktop.setFilter(_buildFilter(value)),
              ),
              PublicationsBookChaptersSectionDesktopVersion(
                bookChaptersStore: _bookChaptersStoreDesktop,
                searchController: _bookChaptersSearchControllerDesktop,
                onSearch: (value) =>
                    _bookChaptersStoreDesktop.setFilter(_buildFilter(value)),
              ),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
