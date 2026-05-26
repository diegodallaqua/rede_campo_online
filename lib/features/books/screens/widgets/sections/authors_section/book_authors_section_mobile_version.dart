import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/books.dart';
import '../../listing/authors/book_authors_list_widget_mobile_version.dart';

class BookAuthorsSectionMobileVersion extends StatelessWidget {
  final Books book;

  const BookAuthorsSectionMobileVersion({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final contributors = book.publication?.contributors ?? [];

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
          BookAuthorsListWidgetMobileVersion(contributors: contributors),
        ],
      ),
    );
  }
}
