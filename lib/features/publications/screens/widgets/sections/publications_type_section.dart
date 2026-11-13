import 'package:flutter/material.dart';

import '../../../../../core/stores/client_paged_store.dart';
import '../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../core/ui/widgets/custom_search_bar.dart';
import '../../../../../core/ui/widgets/section_title.dart';
import '../listing/publications_paged_list.dart';

/// Seção de um tipo de publicação na tela de Publicações: título, busca e
/// listagem paginada.
///
/// Com [gridDelegate] monta o layout desktop (grade); sem ele, o mobile.
class PublicationsTypeSection<T> extends StatefulWidget {
  final String title;
  final String searchHint;
  final ClientPagedStore<T> store;
  final TextEditingController searchController;
  final String errorMessage;
  final String emptyMessage;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final EdgeInsets padding;
  final bool onDarkBackground;
  final SliverGridDelegate? gridDelegate;

  const PublicationsTypeSection({
    super.key,
    required this.title,
    required this.searchHint,
    required this.store,
    required this.searchController,
    required this.errorMessage,
    required this.emptyMessage,
    required this.itemBuilder,
    required this.padding,
    this.onDarkBackground = false,
    this.gridDelegate,
  });

  @override
  State<PublicationsTypeSection<T>> createState() =>
      _PublicationsTypeSectionState<T>();
}

class _PublicationsTypeSectionState<T>
    extends State<PublicationsTypeSection<T>> {
  int _maxDiscoveredPage = 1;

  bool get _dark => widget.onDarkBackground;

  Color get _titleColor =>
      _dark ? CustomColors.fresh_sprout : CustomColors.copper_spice;

  Widget _searchBar() {
    if (_dark) {
      return CustomSearchBar(
        controller: widget.searchController,
        onSubmitted: widget.store.search,
        hintText: widget.searchHint,
      );
    }
    return CustomSearchBar(
      controller: widget.searchController,
      onSubmitted: widget.store.search,
      hintText: widget.searchHint,
      borderColor: CustomColors.midnight_slate,
      textColor: CustomColors.midnight_slate,
      hintColor: CustomColors.midnight_slate,
      iconColor: CustomColors.midnight_slate,
    );
  }

  Widget _list() => PublicationsPagedList<T>(
        store: widget.store,
        itemBuilder: widget.itemBuilder,
        errorMessage: widget.errorMessage,
        emptyMessage: widget.emptyMessage,
        onDarkBackground: _dark,
        gridDelegate: widget.gridDelegate,
        maxDiscoveredPage: _maxDiscoveredPage,
        onPageDiscovered: (newMax) {
          if (newMax > _maxDiscoveredPage) {
            setState(() => _maxDiscoveredPage = newMax);
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    if (widget.gridDelegate == null) {
      return Padding(
        padding: widget.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionTitle.mobile(title: widget.title, color: _titleColor),
            const SizedBox(height: 16),
            _searchBar(),
            const SizedBox(height: 16),
            _list(),
          ],
        ),
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: widget.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: SectionTitle(
                  title: widget.title,
                  color: _titleColor,
                  trailing: _searchBar(),
                ),
              ),
              const SizedBox(height: 24),
              _list(),
            ],
          ),
        ),
      ),
    );
  }
}
