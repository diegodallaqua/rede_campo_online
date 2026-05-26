import 'package:flutter/material.dart';
import 'package:rede_campo_online/features/book_chapters/stores/book_chapters_store.dart';
import '../../listing/publications_book_chapters_list_widget_desktop_version.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';

class PublicationsBookChaptersSectionDesktopVersion extends StatefulWidget {
  final BookChaptersStore bookChaptersStore;

  const PublicationsBookChaptersSectionDesktopVersion({
    super.key,
    required this.bookChaptersStore,
  });

  @override
  State<PublicationsBookChaptersSectionDesktopVersion> createState() =>
      _PublicationsBookChaptersSectionDesktopVersionState();
}

class _PublicationsBookChaptersSectionDesktopVersionState
    extends State<PublicationsBookChaptersSectionDesktopVersion> {
  int _maxDiscoveredPage = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Capítulos de Livros',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: CustomColors.copper_spice,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 64,
                      height: 3,
                      decoration: BoxDecoration(
                        color: CustomColors.copper_spice,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PublicationsBookChaptersListWidgetDesktopVersion(
                bookChaptersStore: widget.bookChaptersStore,
                maxDiscoveredPage: _maxDiscoveredPage,
                onPageDiscovered: (newMax) {
                  if (newMax != _maxDiscoveredPage) {
                    setState(() => _maxDiscoveredPage = newMax);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
