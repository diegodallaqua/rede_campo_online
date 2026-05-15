import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../core/ui/listing_tiles/news/news_tile_desktop_version.dart';
import '../../../../core/ui/theme/custom_colors.dart';
import '../../../news/models/news.dart';
import '../../../news/stores/news_store.dart';

class RecentNewsListWidgetDesktopVersion extends StatefulWidget {
  final NewsStore newsStore;
  final int totalCount;

  const RecentNewsListWidgetDesktopVersion({
    super.key,
    required this.newsStore,
    this.totalCount = 10,
  });

  @override
  State<RecentNewsListWidgetDesktopVersion> createState() =>
      _RecentNewsListWidgetDesktopVersionState();
}

class _RecentNewsListWidgetDesktopVersionState
    extends State<RecentNewsListWidgetDesktopVersion> {
  static const double _listHeight = 315.0;
  final ScrollController _scrollController = ScrollController();

  double _tileWidth = 350.0;
  bool _canScrollLeft = false;
  bool _canScrollRight = true;

  @override
  void initState() {
    super.initState();
    widget.newsStore.loadRecentNews(limit: widget.totalCount);
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
        if (widget.newsStore.showRecentProgress) return _buildLoading();
        if (widget.newsStore.recentNewsError != null &&
            widget.newsStore.recentNews.isEmpty) return _buildError();
        if (widget.newsStore.recentNews.isEmpty) return _buildEmpty();
        return _buildList();
      },
    );
  }

  Widget _buildList() {
    final news = widget.newsStore.recentNews;
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
                _tileWidth =
                    ((constraints.maxWidth - 3 * 16) / 4).clamp(200.0, 350.0);
                return SizedBox(
                  height: _listHeight,
                  child: ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: news.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final item = news[index];
                      return SizedBox(
                        width: _tileWidth,
                        child: NewsTileDesktopVersion(
                          news: item,
                          newsMedia: null,
                          onTap: () => _onNewsTap(item),
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

  void _onNewsTap(News news) {
    // TODO: navegar para a tela de detalhe da notícia.
  }

  Widget _buildLoading() {
    return const SizedBox(
      height: _listHeight,
      child: Center(
        child: CircularProgressIndicator(
          color: CustomColors.fresh_sprout,
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
                color: CustomColors.concrete_mist, size: 36),
            const SizedBox(height: 8),
            const Text(
              'Não foi possível carregar as notícias.',
              style: TextStyle(fontSize: 14, color: CustomColors.concrete_mist),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () =>
                  widget.newsStore.refreshRecentNews(limit: widget.totalCount),
              child: const Text(
                'Tentar novamente',
                style: TextStyle(
                    fontSize: 13,
                    color: CustomColors.fresh_sprout,
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
          'Nenhuma notícia disponível no momento.',
          style: TextStyle(fontSize: 14, color: CustomColors.concrete_mist),
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
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
