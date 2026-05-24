import 'package:flutter/material.dart';
import 'package:rede_campo_online/features/book_chapters/stores/book_chapters_store.dart';
import '../../listing/publications_book_chapters_list_widget_mobile_version.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';

class PublicationsBookChaptersSectionMobileVersion extends StatefulWidget {
  final BookChaptersStore bookChaptersStore;

  const PublicationsBookChaptersSectionMobileVersion({
    super.key,
    required this.bookChaptersStore,
  });

  @override
  State<PublicationsBookChaptersSectionMobileVersion> createState() =>
      _PublicationsBookChaptersSectionMobileVersionState();
}

class _PublicationsBookChaptersSectionMobileVersionState
    extends State<PublicationsBookChaptersSectionMobileVersion> {
  int _maxDiscoveredPage = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Capítulos de Livros',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.copper_spice,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 16),
          PublicationsBookChaptersListWidgetMobileVersion(
            bookChaptersStore: widget.bookChaptersStore,
            maxDiscoveredPage: _maxDiscoveredPage,
            onPageDiscovered: (newMax) {
              if (newMax > _maxDiscoveredPage) {
                setState(() => _maxDiscoveredPage = newMax);
              }
            },
          ),
        ],
      ),
    );
  }
}
