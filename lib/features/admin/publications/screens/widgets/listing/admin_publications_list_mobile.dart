import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/publications/publication_tile_mobile_version.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_search_bar.dart';
import 'package:rede_campo_online/core/ui/widgets/infinite_scroll_list.dart';
import 'package:rede_campo_online/core/ui/widgets/list_status_builder.dart';
import 'package:rede_campo_online/features/admin/publications/stores/admin_publications_store.dart';
import 'package:rede_campo_online/features/publications/models/publications.dart';

/// Listagem mobile do gerenciamento de publicações: busca e lista com
/// rolagem infinita.
class AdminPublicationsListMobile extends StatefulWidget {
  const AdminPublicationsListMobile({
    super.key,
    required this.adminPublicationsStore,
    required this.onTapPublication,
  });

  final AdminPublicationsStore adminPublicationsStore;
  final Future<void> Function(Publications? publication) onTapPublication;

  @override
  State<AdminPublicationsListMobile> createState() =>
      _AdminPublicationsListMobileState();
}

class _AdminPublicationsListMobileState
    extends State<AdminPublicationsListMobile> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    widget.adminPublicationsStore.filterStore.setSearch(value);
    widget.adminPublicationsStore.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: AdminSearchBar(
            controller: _searchController,
            onSubmitted: _onSearch,
          ),
        ),
        Expanded(child: _buildList()),
      ],
    );
  }

  Widget _buildList() {
    return Observer(
      builder: (_) {
        final store = widget.adminPublicationsStore;

        return ListStatusBuilder(
          loading: store.showProgress,
          error: store.error,
          isEmpty: store.list.isEmpty,
          emptyMessage: 'Nenhuma publicação cadastrada.',
          onRetry: store.refreshData,
          builder: (_) => InfiniteScrollList(
            itemCount: store.list.length,
            hasMore: !store.lastPage,
            loading: store.loading,
            onLoadMore: store.loadNextPage,
            onRefresh: store.refreshData,
            itemBuilder: (context, index) {
              final publication = store.list[index];
              return GestureDetector(
                onTap: () => widget.onTapPublication(publication),
                child: PublicationTileMobileVersion(publication: publication),
              );
            },
          ),
        );
      },
    );
  }
}
