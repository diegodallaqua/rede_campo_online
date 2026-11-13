import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/ui/listing_tiles/academic_works/academic_work_tile_desktop_version.dart';
import '../../../core/ui/listing_tiles/academic_works/academic_work_tile_mobile_version.dart';
import '../../../core/ui/listing_tiles/articles/article_tile_desktop_version.dart';
import '../../../core/ui/listing_tiles/articles/article_tile_mobile_version.dart';
import '../../../core/ui/listing_tiles/book_chapters/book_chapter_tile_desktop_version.dart';
import '../../../core/ui/listing_tiles/book_chapters/book_chapter_tile_mobile_version.dart';
import '../../../core/ui/listing_tiles/books/book_tile_desktop_version.dart';
import '../../../core/ui/listing_tiles/books/book_tile_mobile_version.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../../../core/ui/widgets/layout/app_scaffold.dart';
import '../../../core/ui/widgets/layout/footer.dart';
import '../../academic_works/models/academic_work.dart';
import '../../academic_works/stores/academic_work_store.dart';
import '../../articles/models/articles.dart';
import '../../articles/stores/articles_store.dart';
import '../../book_chapters/models/book_chapters.dart';
import '../../book_chapters/stores/book_chapters_store.dart';
import '../../books/models/books.dart';
import '../../books/stores/books_store.dart';
import 'widgets/sections/header_section/publications_header_section_desktop_version.dart';
import 'widgets/sections/header_section/publications_header_section_mobile_version.dart';
import 'widgets/sections/publications_type_section.dart';

class PublicationsScreen extends StatefulWidget {
  const PublicationsScreen({super.key});

  @override
  State<PublicationsScreen> createState() => _PublicationsScreenState();
}

class _PublicationsScreenState extends State<PublicationsScreen> {
  // Lazy: só o layout visível cria (e carrega) seus stores.
  late final _articlesMobile = ArticlesStore(pageSize: 4);
  late final _academicWorksMobile = AcademicWorkStore(pageSize: 4);
  late final _booksMobile = BooksStore(pageSize: 3);
  late final _bookChaptersMobile = BookChaptersStore(pageSize: 3);

  late final _articlesDesktop = ArticlesStore(pageSize: 8);
  late final _academicWorksDesktop = AcademicWorkStore(pageSize: 8);
  late final _booksDesktop = BooksStore(pageSize: 10);
  late final _bookChaptersDesktop = BookChaptersStore(pageSize: 8);

  // Um controller de busca por seção: 0-3 mobile, 4-7 desktop.
  final _searchControllers = List.generate(8, (_) => TextEditingController());

  static const _cardGrid = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 4,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    mainAxisExtent: 180,
  );

  static const _bookGrid = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 5,
    crossAxisSpacing: 16,
    mainAxisSpacing: 16,
    mainAxisExtent: 310,
  );

  @override
  void dispose() {
    for (final controller in _searchControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _open(BuildContext context, String type, int? id, Object extra) =>
      context.push('/publications/$type/$id', extra: extra);

  Widget _articles({required bool desktop}) =>
      PublicationsTypeSection<Articles>(
        title: 'Artigos',
        searchHint: 'Pesquisar artigos',
        store: desktop ? _articlesDesktop : _articlesMobile,
        searchController: _searchControllers[desktop ? 4 : 0],
        errorMessage: 'Não foi possível carregar os artigos.',
        emptyMessage: 'Nenhum artigo encontrado.',
        onDarkBackground: true,
        padding: desktop
            ? const EdgeInsets.only(top: 32, bottom: 16)
            : const EdgeInsets.fromLTRB(16, 24, 16, 24),
        gridDelegate: desktop ? _cardGrid : null,
        itemBuilder: (context, article) {
          void onTap() =>
              _open(context, 'articles', article.publication?.id, article);
          return desktop
              ? ArticleTileDesktopVersion(article: article, onTap: onTap)
              : ArticleTileMobileVersion(article: article, onTap: onTap);
        },
      );

  Widget _academicWorks({required bool desktop}) =>
      PublicationsTypeSection<AcademicWork>(
        title: 'Trabalhos Acadêmicos',
        searchHint: 'Pesquisar trabalhos acadêmicos',
        store: desktop ? _academicWorksDesktop : _academicWorksMobile,
        searchController: _searchControllers[desktop ? 5 : 1],
        errorMessage: 'Não foi possível carregar os trabalhos acadêmicos.',
        emptyMessage: 'Nenhum trabalho acadêmico encontrado.',
        onDarkBackground: true,
        padding: desktop
            ? const EdgeInsets.only(top: 24, bottom: 32)
            : const EdgeInsets.fromLTRB(16, 8, 16, 24),
        gridDelegate: desktop ? _cardGrid : null,
        itemBuilder: (context, work) {
          void onTap() =>
              _open(context, 'academic-works', work.publication?.id, work);
          return desktop
              ? AcademicWorkTileDesktopVersion(academicWork: work, onTap: onTap)
              : AcademicWorkTileMobileVersion(academicWork: work, onTap: onTap);
        },
      );

  Widget _books({required bool desktop}) => PublicationsTypeSection<Books>(
        title: 'Livros',
        searchHint: 'Pesquisar livros',
        store: desktop ? _booksDesktop : _booksMobile,
        searchController: _searchControllers[desktop ? 6 : 2],
        errorMessage: 'Não foi possível carregar os livros.',
        emptyMessage: 'Nenhum livro encontrado.',
        padding: desktop
            ? const EdgeInsets.symmetric(vertical: 32)
            : const EdgeInsets.fromLTRB(16, 24, 16, 24),
        gridDelegate: desktop ? _bookGrid : null,
        itemBuilder: (context, book) {
          void onTap() => _open(context, 'books', book.publication?.id, book);
          return desktop
              ? BookTileDesktopVersion(book: book, onTap: onTap)
              : BookTileMobileVersion(book: book, onTap: onTap);
        },
      );

  Widget _bookChapters({required bool desktop}) =>
      PublicationsTypeSection<BookChapters>(
        title: 'Capítulos de Livros',
        searchHint: 'Pesquisar capítulos de livros',
        store: desktop ? _bookChaptersDesktop : _bookChaptersMobile,
        searchController: _searchControllers[desktop ? 7 : 3],
        errorMessage: 'Não foi possível carregar os capítulos de livros.',
        emptyMessage: 'Nenhum capítulo de livro encontrado.',
        padding: desktop
            ? const EdgeInsets.only(top: 8, bottom: 32)
            : const EdgeInsets.fromLTRB(16, 8, 16, 24),
        gridDelegate: desktop ? _cardGrid : null,
        itemBuilder: (context, chapter) {
          void onTap() =>
              _open(context, 'book-chapters', chapter.publication?.id, chapter);
          return desktop
              ? BookChapterTileDesktopVersion(
                  bookChapter: chapter, onTap: onTap)
              : BookChapterTileMobileVersion(
                  bookChapter: chapter, onTap: onTap);
        },
      );

  Widget _layout({required bool desktop}) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          desktop
              ? const PublicationsHeaderSectionDesktopVersion()
              : const PublicationsHeaderSectionMobileVersion(),
          ColoredBox(
            color: CustomColors.midnight_slate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _articles(desktop: desktop),
                _academicWorks(desktop: desktop),
              ],
            ),
          ),
          if (!desktop) const SizedBox(height: 12),
          _books(desktop: desktop),
          _bookChapters(desktop: desktop),
          const Footer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        // Builder adia o acesso aos stores ao layout visível.
        replacement: Builder(builder: (_) => _layout(desktop: false)),
        child: Builder(builder: (_) => _layout(desktop: true)),
      ),
    );
  }
}
