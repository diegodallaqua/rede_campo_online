import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/news/news_tile_mobile_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';
import 'package:rede_campo_online/features/admin/news/stores/admin_news_store.dart';
import 'package:rede_campo_online/features/news/models/news.dart';

class AdminNewsListWidgetMobileVersion extends StatefulWidget {
  final AdminNewsStore adminNewsStore;
  final Future<void> Function(News? news) onTapNews;

  const AdminNewsListWidgetMobileVersion({
    super.key,
    required this.adminNewsStore,
    required this.onTapNews,
  });

  @override
  State<AdminNewsListWidgetMobileVersion> createState() =>
      _AdminNewsListWidgetMobileVersionState();
}

class _AdminNewsListWidgetMobileVersionState
    extends State<AdminNewsListWidgetMobileVersion> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final adminNewsStore = widget.adminNewsStore;
    if (adminNewsStore.loading || adminNewsStore.lastPage) return;

    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      adminNewsStore.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final adminNewsStore = widget.adminNewsStore;

        if (adminNewsStore.showProgress) {
          return const Center(child: ListLoadingState());
        } else if (adminNewsStore.error != null &&
            adminNewsStore.list.isEmpty) {
          return Center(
            child: ListErrorState(
              message: adminNewsStore.error ??
                  'Não foi possível carregar as notícias.',
              onRetry: adminNewsStore.refreshData,
            ),
          );
        } else if (adminNewsStore.list.isEmpty) {
          return const Center(
            child: ListEmptyState(
              message: 'Nenhuma notícia cadastrada.',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: adminNewsStore.refreshData,
          color: CustomColors.copper_spice,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: adminNewsStore.itemCount,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (index >= adminNewsStore.list.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: CustomColors.copper_spice,
                      ),
                    ),
                  ),
                );
              }

              final news = adminNewsStore.list[index];
              return NewsTileMobileVersion(
                news: news,
                newsMedia: adminNewsStore.mediaMap[news.id],
                onTap: () => widget.onTapNews(news),
                isAdmin: true,
              );
            },
          ),
        );
      },
    );
  }
}
