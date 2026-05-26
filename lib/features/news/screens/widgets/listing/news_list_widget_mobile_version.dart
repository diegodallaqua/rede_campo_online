import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/news/news_tile_mobile_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/arrow_button.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';
import 'package:rede_campo_online/features/news/models/news.dart';
import 'package:rede_campo_online/features/news/models/news_media.dart';
import 'package:rede_campo_online/features/news/repositories/news_media_repository.dart';
import 'package:rede_campo_online/features/news/stores/news_store.dart';

class NewsListWidgetMobileVersion extends StatefulWidget {
  final NewsStore newsStore;
  final int maxDiscoveredPage;
  final ValueChanged<int> onPageDiscovered;

  const NewsListWidgetMobileVersion({
    super.key,
    required this.newsStore,
    required this.maxDiscoveredPage,
    required this.onPageDiscovered,
  });

  @override
  State<NewsListWidgetMobileVersion> createState() =>
      _NewsListWidgetMobileVersionState();
}

class _NewsListWidgetMobileVersionState
    extends State<NewsListWidgetMobileVersion> {
  late final Future<Map<int, NewsMedia>> _mediaFuture;

  @override
  void initState() {
    super.initState();
    _mediaFuture = _loadMedia();
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
      log('NewsListWidgetMobile: erro ao carregar media',
          error: e, stackTrace: s);
      return {};
    }
  }

  void _notifyPageDiscovered(int discovered) {
    final shouldGrow = discovered > widget.maxDiscoveredPage;
    final shouldShrink =
        widget.newsStore.lastPage && discovered < widget.maxDiscoveredPage;
    if (shouldGrow || shouldShrink) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        widget.onPageDiscovered(discovered);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (!widget.newsStore.loading && widget.newsStore.list.isNotEmpty) {
          final discovered =
              widget.newsStore.page + (widget.newsStore.lastPage ? 0 : 1);
          _notifyPageDiscovered(discovered);
        }

        final showPagination = widget.newsStore.list.isNotEmpty &&
            (!widget.newsStore.lastPage ||
                widget.newsStore.page > 1 ||
                widget.maxDiscoveredPage > 1);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.newsStore.showProgress)
              const ListLoadingState()
            else if (widget.newsStore.error != null &&
                widget.newsStore.list.isEmpty)
              ListErrorState(
                message: 'Não foi possível carregar as notícias.',
                onRetry: widget.newsStore.refreshData,
                iconColor: CustomColors.copper_spice,
                messageColor: CustomColors.vanilla_haze,
              )
            else if (widget.newsStore.list.isEmpty)
              const ListEmptyState(
                message: 'Nenhuma notícia encontrada.',
              )
            else
              _buildList(),
            if (showPagination) ...[
              const SizedBox(height: 24),
              _buildPageCarousel(),
            ],
          ],
        );
      },
    );
  }

  Widget _buildList() {
    final newsList = widget.newsStore.list;
    return FutureBuilder<Map<int, NewsMedia>>(
      future: _mediaFuture,
      builder: (context, snapshot) {
        final mediaMap = snapshot.data ?? {};
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: newsList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final news = newsList[index];
            return NewsTileMobileVersion(
              news: news,
              newsMedia: news.id != null ? mediaMap[news.id] : null,
              onTap: () => _onNewsTap(news),
            );
          },
        );
      },
    );
  }

  // ignore: unused_element
  void _onNewsTap(News news) {}

  Widget _buildPageCarousel() {
    final currentPage = widget.newsStore.page;
    final isLastPage = widget.newsStore.lastPage;
    final isLoading = widget.newsStore.loading;

    final knownFromStore = isLastPage ? currentPage : currentPage + 1;
    final effectiveMaxPage = widget.maxDiscoveredPage > knownFromStore
        ? widget.maxDiscoveredPage
        : knownFromStore;

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ArrowButton(
              icon: Icons.chevron_left_rounded,
              enabled: !isLoading && currentPage > 1,
              onTap: () => widget.newsStore.goToPage(currentPage - 1),
              iconColor: CustomColors.midnight_slate,
              disabledIconColor: CustomColors.concrete_mist,
              backgroundColor: Colors.white,
              iconSize: 18,
              borderRadius: 12,
              border: Border.all(color: CustomColors.concrete_mist),
              fixedSize: 33,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              useRipple: false,
            ),
            ...List.generate(effectiveMaxPage, (index) {
              final page = index + 1;
              return _PageNumberButton(
                page: page,
                isActive: page == currentPage,
                enabled: !isLoading,
                onTap: () => widget.newsStore.goToPage(page),
              );
            }),
            if (!isLastPage)
              ArrowButton(
                icon: Icons.chevron_right_rounded,
                enabled: !isLoading,
                onTap: () => widget.newsStore.goToPage(currentPage + 1),
                iconColor: CustomColors.midnight_slate,
                disabledIconColor: CustomColors.concrete_mist,
                backgroundColor: Colors.white,
                iconSize: 18,
                borderRadius: 12,
                border: Border.all(color: CustomColors.concrete_mist),
                fixedSize: 33,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                useRipple: false,
              ),
          ],
        ),
      ),
    );
  }
}

class _PageNumberButton extends StatelessWidget {
  final int page;
  final bool isActive;
  final bool enabled;
  final VoidCallback onTap;

  const _PageNumberButton({
    required this.page,
    required this.isActive,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: enabled && !isActive ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? CustomColors.fresh_sprout : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? CustomColors.fresh_sprout
                  : CustomColors.concrete_mist,
            ),
          ),
          child: Center(
            child: Text(
              '$page',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                color: isActive
                    ? Colors.white
                    : enabled
                        ? CustomColors.midnight_slate
                        : CustomColors.concrete_mist,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
