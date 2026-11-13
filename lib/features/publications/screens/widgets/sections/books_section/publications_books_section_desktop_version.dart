import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/section_title.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/books/stores/books_store.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../listing/books/publications_books_list_widget_desktop_version.dart';

class PublicationsBooksSectionDesktopVersion extends StatefulWidget {
  final BooksStore booksStore;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const PublicationsBooksSectionDesktopVersion({
    super.key,
    required this.booksStore,
    required this.searchController,
    required this.onSearch,
  });

  @override
  State<PublicationsBooksSectionDesktopVersion> createState() =>
      _PublicationsBooksSectionDesktopVersionState();
}

class _PublicationsBooksSectionDesktopVersionState
    extends State<PublicationsBooksSectionDesktopVersion> {
  int _maxDiscoveredPage = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: SectionTitle(
                  title: 'Livros',
                  color: CustomColors.copper_spice,
                  trailing: CustomSearchBar(
                    controller: widget.searchController,
                    onSubmitted: widget.onSearch,
                    hintText: 'Pesquisar livros',
                    borderColor: CustomColors.midnight_slate,
                    textColor: CustomColors.midnight_slate,
                    hintColor: CustomColors.midnight_slate,
                    iconColor: CustomColors.midnight_slate,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PublicationsBooksListWidgetDesktopVersion(
                booksStore: widget.booksStore,
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
