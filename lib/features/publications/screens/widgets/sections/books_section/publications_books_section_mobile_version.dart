import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/books/stores/books_store.dart';
import '../../listing/books/publications_books_list_widget_mobile_version.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';

class PublicationsBooksSectionMobileVersion extends StatefulWidget {
  final BooksStore booksStore;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const PublicationsBooksSectionMobileVersion({
    super.key,
    required this.booksStore,
    required this.searchController,
    required this.onSearch,
  });

  @override
  State<PublicationsBooksSectionMobileVersion> createState() =>
      _PublicationsBooksSectionMobileVersionState();
}

class _PublicationsBooksSectionMobileVersionState
    extends State<PublicationsBooksSectionMobileVersion> {
  int _maxDiscoveredPage = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Livros',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.copper_spice,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 16),
          CustomSearchBar(
            controller: widget.searchController,
            onSubmitted: widget.onSearch,
            hintText: 'Pesquisar livros',
            borderColor: CustomColors.midnight_slate,
            textColor: CustomColors.midnight_slate,
            hintColor: CustomColors.midnight_slate,
            iconColor: CustomColors.midnight_slate,
          ),
          const SizedBox(height: 16),
          PublicationsBooksListWidgetMobileVersion(
            booksStore: widget.booksStore,
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
