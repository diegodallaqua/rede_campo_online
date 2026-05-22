import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../core/ui/listing_tiles/publications/publication_tile_mobile_version.dart';
import '../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../core/ui/widgets/list_empty_state.dart';
import '../../../../../core/ui/widgets/list_error_state.dart';
import '../../../../../core/ui/widgets/list_loading_state.dart';
import '../../../../publications/models/publications.dart';
import '../../../../publications/stores/publications_store.dart';

class PublicationsListWidgetMobileVersion extends StatefulWidget {
  final PublicationsStore publicationsStore;

  final int visibleCount;

  final int totalCount;

  static const double _tileHeight = 110.0;
  static const double _separatorHeight = 8.0;

  const PublicationsListWidgetMobileVersion({
    super.key,
    required this.publicationsStore,
    this.visibleCount = 3,
    this.totalCount = 10,
  });

  @override
  State<PublicationsListWidgetMobileVersion> createState() =>
      _HomePublicationsListWidgetState();
}

class _HomePublicationsListWidgetState
    extends State<PublicationsListWidgetMobileVersion> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.publicationsStore.loadRecentPublications(limit: widget.totalCount);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Calcula a altura visível para [n] itens, incluindo seus separadores.
  double _heightForItems(int n) {
    if (n <= 0) return 0;
    return (n * PublicationsListWidgetMobileVersion._tileHeight) +
        ((n - 1) * PublicationsListWidgetMobileVersion._separatorHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (widget.publicationsStore.showRecentProgress) {
          return const ListLoadingState(
            color: CustomColors.copper_spice,
          );
        } else if (widget.publicationsStore.recentPublicationsError != null &&
            widget.publicationsStore.recentPublications.isEmpty) {
          return ListErrorState(
            message: 'Não foi possível carregar as publicações.',
            onRetry: () => widget.publicationsStore
                .refreshRecentPublications(limit: widget.totalCount),
            iconColor: CustomColors.copper_spice,
            messageColor: CustomColors.pine_shadow,
          );
        } else if (widget.publicationsStore.recentPublications.isEmpty) {
          return const ListEmptyState(
            message: 'Nenhuma publicação encontrada.',
          );
        }

        return _buildList();
      },
    );
  }

  Widget _buildList() {
    final publications = widget.publicationsStore.recentPublications;

    final double maxHeight = _heightForItems(widget.visibleCount);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Scrollbar(
        thumbVisibility: true,
        controller: _scrollController,
        child: ListView.separated(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          shrinkWrap: false,
          padding: EdgeInsets.zero,
          itemCount: publications.length,
          separatorBuilder: (_, __) => const SizedBox(
            height: PublicationsListWidgetMobileVersion._separatorHeight,
          ),
          itemBuilder: (context, index) {
            final item = publications[index];

            return PublicationTileMobileVersion(
              publication: item,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              onTap: () => _onPublicationTap(item),
            );
          },
        ),
      ),
    );
  }

  void _onPublicationTap(Publications publication) {
    // TODO: navegar para a tela de detalhe da publicação.
  }
}
