import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/publications/publication_tile_desktop_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_search_bar.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_section_header.dart';
import 'package:rede_campo_online/core/ui/widgets/list_status_builder.dart';
import 'package:rede_campo_online/core/ui/widgets/pagination_bar.dart';
import 'package:rede_campo_online/features/admin/publications/stores/admin_publications_store.dart';
import 'package:rede_campo_online/features/publications/models/publications.dart';

/// Listagem desktop do gerenciamento de publicações: cabeçalho da seção,
/// busca, grade paginada e barra de paginação numerada.
class AdminPublicationsListDesktop extends StatefulWidget {
  const AdminPublicationsListDesktop({
    super.key,
    required this.adminPublicationsStore,
    required this.onTapPublication,
  });

  final AdminPublicationsStore adminPublicationsStore;
  final Future<void> Function(Publications? publication) onTapPublication;

  @override
  State<AdminPublicationsListDesktop> createState() =>
      _AdminPublicationsListDesktopState();
}

class _AdminPublicationsListDesktopState
    extends State<AdminPublicationsListDesktop> {
  final TextEditingController _searchController = TextEditingController();

  // Maior página já vista na navegação; mantém os números visíveis mesmo
  // quando o store ainda não conhece o total de páginas.
  int _maxDiscoveredPage = 1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    widget.adminPublicationsStore.filterStore.setSearch(value);
    widget.adminPublicationsStore.refreshData();
    setState(() => _maxDiscoveredPage = 1);
  }

  void _notifyPageDiscovered(int discovered) {
    final shouldGrow = discovered > _maxDiscoveredPage;
    final shouldShrink = widget.adminPublicationsStore.lastPage &&
        discovered < _maxDiscoveredPage;
    if (shouldGrow || shouldShrink) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _maxDiscoveredPage = discovered);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminSectionHeader(
          title: 'Gerenciar Publicações',
          subtitle: 'Selecione uma publicação para editar.',
          onBack: () => context.pop(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
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

        if (!store.loading &&
            store.list.isNotEmpty &&
            store.lastPageKnown &&
            !store.lastPage) {
          _notifyPageDiscovered(store.page + 1);
        }

        return ListStatusBuilder(
          loading: store.showProgress,
          error: store.error,
          isEmpty: store.list.isEmpty,
          emptyMessage: 'Nenhuma publicação cadastrada.',
          onRetry: store.refreshData,
          builder: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: store.refreshData,
                  color: CustomColors.copper_spice,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 24),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: _buildGrid(store),
                  ),
                ),
              ),
              _buildPaginationFooter(store),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGrid(AdminPublicationsStore store) {
    final publicationsList = store.list;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 200,
      ),
      itemCount: publicationsList.length,
      itemBuilder: (context, index) {
        final publication = publicationsList[index];
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => widget.onTapPublication(publication),
            child: PublicationTileDesktopVersion(publication: publication),
          ),
        );
      },
    );
  }

  Widget _buildPaginationFooter(AdminPublicationsStore store) {
    final hasNextPage = store.lastPageKnown && !store.lastPage;
    final knownFromStore = hasNextPage ? store.page + 1 : store.page;
    final effectiveMaxPage = _maxDiscoveredPage > knownFromStore
        ? _maxDiscoveredPage
        : knownFromStore;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(40, 16, 40, 24),
      decoration: BoxDecoration(
        color: CustomColors.vanilla_haze.withOpacity(0.5),
        border: Border(
          top: BorderSide(
            color: CustomColors.concrete_mist.withOpacity(0.5),
          ),
        ),
      ),
      child: PaginationBar(
        currentPage: store.page,
        pageCount: effectiveMaxPage,
        hasNextPage: hasNextPage,
        enabled: !store.loading,
        onPageSelected: store.goToPage,
      ),
    );
  }
}
