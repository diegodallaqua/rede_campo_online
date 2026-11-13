import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/section_title.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/book_chapters/stores/book_chapters_store.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../listing/book_chapters/publications_book_chapters_list_widget_desktop_version.dart';

class PublicationsBookChaptersSectionDesktopVersion extends StatefulWidget {
  final BookChaptersStore bookChaptersStore;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const PublicationsBookChaptersSectionDesktopVersion({
    super.key,
    required this.bookChaptersStore,
    required this.searchController,
    required this.onSearch,
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
                child: SectionTitle(
                  title: 'Capítulos de Livros',
                  color: CustomColors.copper_spice,
                  trailing: CustomSearchBar(
                    controller: widget.searchController,
                    onSubmitted: widget.onSearch,
                    hintText: 'Pesquisar capítulos de livros',
                    borderColor: CustomColors.midnight_slate,
                    textColor: CustomColors.midnight_slate,
                    hintColor: CustomColors.midnight_slate,
                    iconColor: CustomColors.midnight_slate,
                  ),
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
