import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/book_chapters.dart';
import '../../listing/authors/book_chapter_authors_list_widget_desktop_version.dart';

class BookChapterAuthorsSectionDesktopVersion extends StatelessWidget {
  final BookChapters bookChapter;

  const BookChapterAuthorsSectionDesktopVersion({
    super.key,
    required this.bookChapter,
  });

  @override
  Widget build(BuildContext context) {
    final contributors = bookChapter.publication?.contributors ?? [];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 24, 48, 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Text(
                    'Autores do Capítulo',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.fresh_sprout,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            CustomColors.fresh_sprout.withOpacity(0.4),
                            CustomColors.fresh_sprout.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              BookChapterAuthorsListWidgetDesktopVersion(
                contributors: contributors,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
