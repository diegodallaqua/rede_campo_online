import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/news/news_tile_desktop_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/arrow_button.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';
import 'package:rede_campo_online/features/news/models/news.dart';
import 'package:rede_campo_online/features/news/models/news_media.dart';
import 'package:rede_campo_online/features/news/repositories/news_media_repository.dart';
import 'package:rede_campo_online/features/news/stores/news_store.dart';

class NewsListWidgetDesktopVersion extends StatefulWidget {
  final NewsStore newsStore;
  final int maxDiscoveredPage;
  final ValueChanged<int> onPageDiscovered;

  const NewsListWidgetDesktopVersion({
    super.key,
    required this.newsStore,
    required this.maxDiscoveredPage,
    required this.onPageDiscovered,
  });

  @override
  State<NewsListWidgetDesktopVersion> createState() =>
      _NewsListWidgetDesktopVersionState();
}

class _NewsListWidgetDesktopVersionState
    extends State<NewsListWidgetDesktopVersion> {
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
      log('NewsListWidgetDesktop: erro ao carregar media', error: e, stackTrace: s);
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

        if (widget.newsStore.showProgress) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: ListLoadingState(color: CustomColors.fresh_sprout),
          );
        } else if (widget.newsStore.error != null &&
            widget.newsStore.list.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: ListErrorState(
              message: 'Não foi possível carregar as notícias.',
              onRetry: () => widget.newsStore.refreshData(),
              iconColor: CustomColors.copper_spice,
              messageColor: CustomColors.vanilla_haze,
            ),
          );
        } else if (widget.newsStore.list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: ListEmptyState(
              message: 'Nenhuma notícia encontrada.',
              messageColor: CustomColors.vanilla_haze,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGrid(),
            if (showPagination) ...[
              const SizedBox(height: 24),
              _buildPagination(),
            ],
          ],
        );
      },
    );
  }

  Widget _buildGrid() {
    final newsList = widget.newsStore.list;
    return FutureBuilder<Map<int, NewsMedia>>(
      future: _mediaFuture,
      builder: (context, snapshot) {
        final mediaMap = snapshot.data ?? {};
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 310,
            ),
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final item = newsList[index];
              return NewsTileDesktopVersion(
                news: item,
                newsMedia: item.id != null ? mediaMap[item.id] : null,
                onTap: () => _onNewsTap(item),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPagination() {
    final currentPage = widget.newsStore.page;
    final isLastPage = widget.newsStore.lastPage;
    final isLoading = widget.newsStore.loading;

    final knownFromStore = isLastPage ? currentPage : currentPage + 1;
    final effectiveMaxPage = widget.maxDiscoveredPage > knownFromStore
        ? widget.maxDiscoveredPage
        : knownFromStore;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ArrowButton(
            icon: Icons.chevron_left_rounded,
            enabled: !isLoading && currentPage > 1,
            onTap: () => widget.newsStore.goToPage(currentPage - 1),
            iconColor: CustomColors.vanilla_haze,
            disabledIconColor: CustomColors.concrete_mist,
            backgroundColor: Colors.white.withOpacity(0.1),
            iconSize: 18,
            borderRadius: 12,
            fixedSize: 36,
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
              iconColor: CustomColors.vanilla_haze,
              disabledIconColor: CustomColors.concrete_mist,
              backgroundColor: Colors.white.withOpacity(0.1),
              iconSize: 18,
              borderRadius: 12,
              fixedSize: 36,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              useRipple: false,
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
            color: isActive
                ? CustomColors.fresh_sprout
                : CustomColors.vanilla_haze.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? CustomColors.fresh_sprout
                  : CustomColors.vanilla_haze.withOpacity(0.3),
            ),
          ),
          child: Center(
            child: Text(
              '$page',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                color: enabled
                    ? CustomColors.vanilla_haze
                    : CustomColors.concrete_mist,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
