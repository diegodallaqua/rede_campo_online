import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:go_router/go_router.dart';
import '../../../../../../app/router.dart';
import '../../../../../../core/ui/listing_tiles/news/news_tile_desktop_version.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/arrow_button.dart';
import '../../../../../../core/ui/widgets/list_empty_state.dart';
import '../../../../../../core/ui/widgets/list_error_state.dart';
import '../../../../../../core/ui/widgets/list_loading_state.dart';
import '../../../../../news/models/news.dart';
import '../../../../../news/models/news_media.dart';
import '../../../../../news/repositories/news_media_repository.dart';
import '../../../../../news/stores/news_store.dart';

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

  late final Future<Map<int, NewsMedia>> _mediaFuture;
  double _tileWidth = 350.0;
  bool _canScrollLeft = false;
  bool _canScrollRight = true;

  @override
  void initState() {
    super.initState();
    widget.newsStore.loadRecentNews(limit: widget.totalCount);
    _scrollController.addListener(_updateArrowState);
    _mediaFuture = _loadMedia();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateArrowState);
    _scrollController.dispose();
    super.dispose();
  }

  Future<Map<int, NewsMedia>> _loadMedia() async {
    try {
      final mediaList = await NewsMediaRepository().findAll();
      final map = <int, NewsMedia>{};
      for (final m in mediaList) {
        final newsId = m.news?.id;
        if (newsId != null && !map.containsKey(newsId)) {
          map[newsId] = m;
        }
      }
      return map;
    } catch (e, s) {
      log('RecentNewsListWidgetDesktop: erro ao carregar media',
          error: e, stackTrace: s);
      return {};
    }
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
    _scrollController.animateTo(target,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _scrollRight() {
    final target = (_scrollController.offset + _tileWidth + 16)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(target,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (widget.newsStore.showRecentProgress) {
          return const ListLoadingState(color: CustomColors.fresh_sprout);
        } else if (widget.newsStore.recentNewsError != null &&
            widget.newsStore.recentNews.isEmpty) {
          return ListErrorState(
            message: 'Não foi possível carregar as notícias.',
            onRetry: () =>
                widget.newsStore.refreshRecentNews(limit: widget.totalCount),
            iconColor: CustomColors.copper_spice,
            messageColor: CustomColors.vanilla_haze,
          );
        } else if (widget.newsStore.recentNews.isEmpty) {
          return const ListEmptyState(
            message: 'Nenhuma notícia encontrada.',
            messageColor: CustomColors.vanilla_haze,
          );
        }
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
          ArrowButton(
            icon: Icons.chevron_left_rounded,
            enabled: _canScrollLeft,
            onTap: _scrollLeft,
            iconColor: CustomColors.vanilla_haze,
            backgroundColor: Colors.white.withOpacity(0.1),
            disabledOpacity: 0.25,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                _tileWidth =
                    ((constraints.maxWidth - 3 * 16) / 4).clamp(200.0, 350.0);
                return SizedBox(
                  height: _listHeight,
                  child: FutureBuilder<Map<int, NewsMedia>>(
                    future: _mediaFuture,
                    builder: (context, snapshot) {
                      final mediaMap = snapshot.data ?? {};
                      return ListView.separated(
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
                              newsMedia:
                                  item.id != null ? mediaMap[item.id] : null,
                              onTap: () => _onNewsTap(item),
                            ),
                          );
                        },
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
            iconColor: CustomColors.vanilla_haze,
            backgroundColor: Colors.white.withOpacity(0.1),
            disabledOpacity: 0.25,
          ),
        ],
      ),
    );
  }

  void _onNewsTap(News news) {
    context.go(
      AppRoutes.newsDetail.replaceFirst(':id', '${news.id}'),
      extra: news,
    );
  }
}
