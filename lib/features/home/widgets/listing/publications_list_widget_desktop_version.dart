import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../core/ui/listing_tiles/publications/publication_tile_desktop_version.dart';
import '../../../../core/ui/theme/custom_colors.dart';
import '../../../publications/models/publications.dart';
import '../../../publications/stores/publications_store.dart';

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
        if (widget.publicationsStore.showRecentProgress) return _buildLoading();
        if (widget.publicationsStore.recentPublicationsError != null &&
            widget.publicationsStore.recentPublications.isEmpty) {
          return _buildError();
        }
        if (widget.publicationsStore.recentPublications.isEmpty) {
          return _buildEmpty();
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
          _ArrowButton(
            icon: Icons.chevron_left_rounded,
            enabled: _canScrollLeft,
            onTap: _scrollLeft,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                _tileWidth = ((constraints.maxWidth - 3 * 16) / 4)
                    .clamp(200.0, 320.0);
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
          _ArrowButton(
            icon: Icons.chevron_right_rounded,
            enabled: _canScrollRight,
            onTap: _scrollRight,
          ),
        ],
      ),
    );
  }

  void _onPublicationTap(Publications publication) {
    // TODO: navegar para a tela de detalhe da publicação.
  }

  Widget _buildLoading() {
    return const SizedBox(
      height: _listHeight,
      child: Center(
        child: CircularProgressIndicator(
          color: CustomColors.copper_spice,
          strokeWidth: 2.5,
        ),
      ),
    );
  }

  Widget _buildError() {
    return SizedBox(
      height: _listHeight,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                color: CustomColors.pine_shadow, size: 36),
            const SizedBox(height: 8),
            const Text(
              'Não foi possível carregar as publicações.',
              style: TextStyle(fontSize: 14, color: CustomColors.pine_shadow),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => widget.publicationsStore
                  .refreshRecentPublications(limit: widget.totalCount),
              child: const Text(
                'Tentar novamente',
                style: TextStyle(
                    fontSize: 13,
                    color: CustomColors.copper_spice,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const SizedBox(
      height: _listHeight,
      child: Center(
        child: Text(
          'Nenhuma publicação disponível no momento.',
          style: TextStyle(fontSize: 14, color: CustomColors.pine_shadow),
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _ArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.25,
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: CustomColors.midnight_slate.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: CustomColors.midnight_slate,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
