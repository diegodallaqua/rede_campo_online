import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../../core/ui/listing_tiles/publications/publication_tile_desktop_version.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/arrow_button.dart';
import '../../../../../../core/ui/widgets/list_empty_state.dart';
import '../../../../../../core/ui/widgets/list_error_state.dart';
import '../../../../../../core/ui/widgets/list_loading_state.dart';
import '../../../../../publications/models/publications.dart';
import '../../../../../publications/stores/publications_store.dart';

class PublicationsListWidgetDesktopVersion extends StatefulWidget {
  final PublicationsStore publicationsStore;
  final int totalCount;

  const PublicationsListWidgetDesktopVersion({
    super.key,
    required this.publicationsStore,
    this.totalCount = 10,
  });

  @override
  State<PublicationsListWidgetDesktopVersion> createState() =>
      _PublicationsListWidgetDesktopVersionState();
}

class _PublicationsListWidgetDesktopVersionState
    extends State<PublicationsListWidgetDesktopVersion> {
  static const double _listHeight = 240.0;
  final ScrollController _scrollController = ScrollController();

  double _tileWidth = 300.0;
  bool _canScrollLeft = false;
  bool _canScrollRight = true;

  @override
  void initState() {
    super.initState();
    widget.publicationsStore.loadRecentPublications(limit: widget.totalCount);
    _scrollController.addListener(_updateArrowState);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateArrowState);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateArrowState() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    setState(() {
      _canScrollLeft = pos.pixels > 0;
      _canScrollRight = pos.pixels < pos.maxScrollExtent;
    });
  }

  void _scrollLeft() {
    final target = (_scrollController.offset - _tileWidth - 16)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    final target = (_scrollController.offset + _tileWidth + 16)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        children: [
          ArrowButton(
            icon: Icons.chevron_left_rounded,
            enabled: _canScrollLeft,
            onTap: _scrollLeft,
            iconColor: CustomColors.midnight_slate,
            backgroundColor: CustomColors.midnight_slate.withOpacity(0.08),
            disabledOpacity: 0.25,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                _tileWidth =
                    ((constraints.maxWidth - 3 * 16) / 4).clamp(200.0, 320.0);
                return SizedBox(
                  height: _listHeight,
                  child: ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: publications.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final item = publications[index];
                      return SizedBox(
                        width: _tileWidth,
                        child: PublicationTileDesktopVersion(
                          publication: item,
                          onTap: () => _onPublicationTap(item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          ArrowButton(
            icon: Icons.chevron_right_rounded,
            enabled: _canScrollRight,
            onTap: _scrollRight,
            iconColor: CustomColors.midnight_slate,
            backgroundColor: CustomColors.midnight_slate.withOpacity(0.08),
            disabledOpacity: 0.25,
          ),
        ],
      ),
    );
  }

  void _onPublicationTap(Publications publication) {
    // TODO: navegar para a tela de detalhe da publicação.
  }
}
