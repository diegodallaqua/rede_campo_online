import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/ui/layout/app_scaffold.dart';
import '../../../core/ui/layout/footer.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../models/books.dart';
import 'widgets/sections/authors_section/book_authors_section_desktop_version.dart';
import 'widgets/sections/authors_section/book_authors_section_mobile_version.dart';
import 'widgets/sections/header_section/book_header_section_desktop_version.dart';
import 'widgets/sections/header_section/book_header_section_mobile_version.dart';

class BookDetailsScreen extends StatelessWidget {
  final Books book;

  const BookDetailsScreen({super.key, required this.book});

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
              BookHeaderSectionMobileVersion(book: book),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: BookAuthorsSectionMobileVersion(book: book),
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
              BookHeaderSectionDesktopVersion(book: book),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: BookAuthorsSectionDesktopVersion(book: book),
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
