import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/book_chapters.dart';
import '../../listing/book_chapter_authors_list_widget_mobile_version.dart';

class BookChapterAuthorsSectionMobileVersion extends StatelessWidget {
  final BookChapters bookChapter;

  const BookChapterAuthorsSectionMobileVersion({
    super.key,
    required this.bookChapter,
  });

  @override
  Widget build(BuildContext context) {
    final contributors = bookChapter.publication?.contributors ?? [];

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Autores',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          BookChapterAuthorsListWidgetMobileVersion(
            contributors: contributors,
          ),
        ],
      ),
    );
  }
}
