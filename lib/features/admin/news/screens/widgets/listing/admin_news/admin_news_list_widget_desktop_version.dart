import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/news/news_tile_desktop_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/arrow_button.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';
import 'package:rede_campo_online/features/admin/news/stores/admin_news_store.dart';
import 'package:rede_campo_online/features/news/models/news.dart';

class AdminNewsListWidgetDesktopVersion extends StatefulWidget {
  final AdminNewsStore adminNewsStore;
  final int maxDiscoveredPage;
  final ValueChanged<int> onPageDiscovered;
  final Future<void> Function(News? news) onTapNews;

  const AdminNewsListWidgetDesktopVersion({
    super.key,
    required this.adminNewsStore,
    required this.maxDiscoveredPage,
    required this.onPageDiscovered,
    required this.onTapNews,
  });

  @override
  State<AdminNewsListWidgetDesktopVersion> createState() =>
      _AdminNewsListWidgetDesktopVersionState();
}

class _AdminNewsListWidgetDesktopVersionState
    extends State<AdminNewsListWidgetDesktopVersion> {
  void _notifyPageDiscovered(int discovered) {
    final shouldGrow = discovered > widget.maxDiscoveredPage;
    final shouldShrink = widget.adminNewsStore.lastPage &&
        discovered < widget.maxDiscoveredPage;
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
        final adminNewsStore = widget.adminNewsStore;

        if (!adminNewsStore.loading &&
            adminNewsStore.list.isNotEmpty &&
            adminNewsStore.lastPageKnown &&
            !adminNewsStore.lastPage) {
          _notifyPageDiscovered(adminNewsStore.page + 1);
        }

        final showPagination = adminNewsStore.list.isNotEmpty;

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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: adminNewsStore.refreshData,
                color: CustomColors.copper_spice,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 24),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _buildGrid(adminNewsStore),
                ),
              ),
            ),
            if (showPagination)
              Container(
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
                child: _buildPagination(adminNewsStore),
              ),
          ],
        );
      },
    );
  }

  Widget _buildGrid(AdminNewsStore adminNewsStore) {
    final newsList = adminNewsStore.list;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 310,
      ),
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        final news = newsList[index];
        return NewsTileDesktopVersion(
          news: news,
          newsMedia: adminNewsStore.mediaMap[news.id],
          onTap: () => widget.onTapNews(news),
          isAdmin: true,
        );
      },
    );
  }

  Widget _buildPagination(AdminNewsStore adminNewsStore) {
    final currentPage = adminNewsStore.page;
    final hasNextPage = adminNewsStore.lastPageKnown && !adminNewsStore.lastPage;
    final isLoading = adminNewsStore.loading;

    final knownFromStore = hasNextPage ? currentPage + 1 : currentPage;
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
            onTap: () => adminNewsStore.goToPage(currentPage - 1),
            iconColor: CustomColors.midnight_slate,
            disabledIconColor: CustomColors.concrete_mist,
            backgroundColor: Colors.white,
            iconSize: 18,
            borderRadius: 12,
            border: Border.all(color: CustomColors.concrete_mist),
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
              onTap: () => adminNewsStore.goToPage(page),
            );
          }),
          if (hasNextPage)
            ArrowButton(
              icon: Icons.chevron_right_rounded,
              enabled: !isLoading,
              onTap: () => adminNewsStore.goToPage(currentPage + 1),
              iconColor: CustomColors.midnight_slate,
              disabledIconColor: CustomColors.concrete_mist,
              backgroundColor: Colors.white,
              iconSize: 18,
              borderRadius: 12,
              border: Border.all(color: CustomColors.concrete_mist),
              fixedSize: 36,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              useRipple: false,
            ),
        ],
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
            color: isActive ? CustomColors.copper_spice : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? CustomColors.copper_spice
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
