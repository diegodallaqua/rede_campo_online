import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../core/ui/widgets/list_empty_state.dart';
import '../../../../core/ui/widgets/list_error_state.dart';
import '../../../../core/ui/widgets/list_loading_state.dart';
import '../../../../features/news/models/news.dart';
import '../../../../features/news/models/news_media.dart';
import '../../../../features/news/stores/news_store.dart';
import '../../../../core/ui/listing_tiles/news/news_tile_mobile_version.dart';
import '../../../../core/ui/theme/custom_colors.dart';

class RecentNewsListWidgetMobileVersion extends StatefulWidget {
  final NewsStore newsStore;

  final int visibleCount;

  final int totalCount;

  static const double _tileHeight = 110.0;
  static const double _separatorHeight = 8.0;

  const RecentNewsListWidgetMobileVersion({
    super.key,
    required this.newsStore,
    this.visibleCount = 3,
    this.totalCount = 10,
  });

  @override
  State<RecentNewsListWidgetMobileVersion> createState() =>
      _RecentNewsListWidgetMobileVersionState();
}

class _RecentNewsListWidgetMobileVersionState
    extends State<RecentNewsListWidgetMobileVersion> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.newsStore.loadRecentNews(limit: widget.totalCount);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Calcula a altura visível para [n] itens, incluindo seus separadores.
  double _heightForItems(int n) {
    if (n <= 0) return 0;
    return (n * RecentNewsListWidgetMobileVersion._tileHeight) +
        ((n - 1) * RecentNewsListWidgetMobileVersion._separatorHeight);
  }

  // Busca o [NewsMedia] correspondente à notícia por id.
  // Retorna null com segurança caso não exista correspondência.
  NewsMedia? _mediaForNews(News news, List<NewsMedia> mediaList) {
    try {
      return mediaList.firstWhere((m) => m.news?.id == news.id);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (widget.newsStore.showRecentProgress) {
          return const ListLoadingState(
            color: CustomColors.fresh_sprout,
          );
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
          itemCount: news.length,
          separatorBuilder: (_, __) => const SizedBox(
            height: RecentNewsListWidgetMobileVersion._separatorHeight,
          ),
          itemBuilder: (context, index) {
            final item = news[index];

            final media = _mediaForNews(
              item,
              [],
            );

            return NewsTileMobileVersion(
              news: item,
              newsMedia: media,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              onTap: () => _onNewsTap(item),
            );
          },
        ),
      ),
    );
  }

  void _onNewsTap(News news) {
    // TODO: navegar para a tela de detalhe da notícia.
  }
}
