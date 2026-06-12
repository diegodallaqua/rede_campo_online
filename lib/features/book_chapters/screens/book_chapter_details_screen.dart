import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/ui/sections/authors_section.dart';
import '../../../core/ui/widgets/layout/app_scaffold.dart';
import '../../../core/ui/widgets/layout/footer.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../models/book_chapters.dart';
import 'widgets/sections/header_section/book_chapter_header_section_desktop_version.dart';
import 'widgets/sections/header_section/book_chapter_header_section_mobile_version.dart';

class BookChapterDetailsScreen extends StatelessWidget {
  final BookChapters bookChapter;

  const BookChapterDetailsScreen({super.key, required this.bookChapter});

  static const _authorsEmptyMessage = 'Nenhum autor vinculado a este capítulo.';

  @override
  Widget build(BuildContext context) {
    final contributors = bookChapter.publication?.contributors ?? [];

    return AppScaffold(
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BookChapterHeaderSectionMobileVersion(bookChapter: bookChapter),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: AuthorsSectionMobileVersion(
                  title: 'Autores',
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
              BookChapterHeaderSectionDesktopVersion(bookChapter: bookChapter),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: AuthorsSectionDesktopVersion(
                  title: 'Autores do Capítulo',
                  emptyMessage: _authorsEmptyMessage,
                  contributors: contributors,
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
