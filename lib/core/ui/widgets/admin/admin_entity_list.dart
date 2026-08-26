import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../stores/paged_store.dart';
import '../../theme/custom_colors.dart';
import '../list_empty_state.dart';
import '../list_error_state.dart';
import '../list_loading_state.dart';
import '../pagination_bar.dart';

/// Constrói o item de uma listagem administrativa a partir da entidade.
typedef AdminEntityItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

/// Listagem administrativa desktop: grade paginada com barra de páginas
/// numeradas, estados de carregamento/erro/vazio e pull-to-refresh.
/// Genérica sobre qualquer [PagedStore].
class AdminEntityListDesktopVersion<T> extends StatefulWidget {
  final PagedStore<T> store;
  final int maxDiscoveredPage;
  final ValueChanged<int> onPageDiscovered;
  final String errorMessage;
  final String emptyMessage;
  final AdminEntityItemBuilder<T> itemBuilder;
  final SliverGridDelegate gridDelegate;

  const AdminEntityListDesktopVersion({
    super.key,
    required this.store,
    required this.maxDiscoveredPage,
    required this.onPageDiscovered,
    required this.errorMessage,
    required this.emptyMessage,
    required this.itemBuilder,
    this.gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 6,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      mainAxisExtent: 310,
    ),
  });

  @override
  State<AdminEntityListDesktopVersion<T>> createState() =>
      _AdminEntityListDesktopVersionState<T>();
}

class _AdminEntityListDesktopVersionState<T>
    extends State<AdminEntityListDesktopVersion<T>> {
  void _notifyPageDiscovered(int discovered) {
    final shouldGrow = discovered > widget.maxDiscoveredPage;
    final shouldShrink =
        widget.store.lastPage && discovered < widget.maxDiscoveredPage;
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
        final store = widget.store;

        if (!store.loading &&
            store.list.isNotEmpty &&
            store.lastPageKnown &&
            !store.lastPage) {
          _notifyPageDiscovered(store.page + 1);
        }

        final showPagination = store.list.isNotEmpty;

        if (store.showProgress) {
          return const Center(child: ListLoadingState());
        } else if (store.error != null && store.list.isEmpty) {
          return Center(
            child: ListErrorState(
              message: store.error ?? widget.errorMessage,
              onRetry: store.refreshData,
              iconColor: CustomColors.copper_spice,
            ),
          );
        } else if (store.list.isEmpty) {
          return Center(
            child: ListEmptyState(
                message: widget.emptyMessage,
                iconColor: CustomColors.copper_spice),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: store.refreshData,
                color: CustomColors.copper_spice,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 24),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _buildGrid(store),
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
                child: _buildPagination(store),
              ),
          ],
        );
      },
    );
  }

  Widget _buildGrid(PagedStore<T> store) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: widget.gridDelegate,
      itemCount: store.list.length,
      itemBuilder: (context, index) =>
          widget.itemBuilder(context, store.list[index]),
    );
  }

  Widget _buildPagination(PagedStore<T> store) {
    final currentPage = store.page;
    final hasNextPage = store.lastPageKnown && !store.lastPage;
    final isLoading = store.loading;

    final knownFromStore = hasNextPage ? currentPage + 1 : currentPage;
    final effectiveMaxPage = widget.maxDiscoveredPage > knownFromStore
        ? widget.maxDiscoveredPage
        : knownFromStore;

    return PaginationBar(
      currentPage: currentPage,
      pageCount: effectiveMaxPage,
      hasNextPage: hasNextPage,
      enabled: !isLoading,
      onPageSelected: store.goToPage,
    );
  }
}

/// Listagem administrativa mobile com rolagem infinita. Usa grade quando
/// [gridDelegate] é informado, senão uma lista vertical separada por
/// [listSeparatorHeight].
class AdminEntityListMobileVersion<T> extends StatefulWidget {
  final PagedStore<T> store;
  final String errorMessage;
  final String emptyMessage;
  final AdminEntityItemBuilder<T> itemBuilder;
  final SliverGridDelegate? gridDelegate;
  final double listSeparatorHeight;
  final EdgeInsets padding;

  const AdminEntityListMobileVersion({
    super.key,
    required this.store,
    required this.errorMessage,
    required this.emptyMessage,
    required this.itemBuilder,
    this.gridDelegate,
    this.listSeparatorHeight = 10,
    this.padding = const EdgeInsets.fromLTRB(16, 20, 16, 110),
  });

  @override
  State<AdminEntityListMobileVersion<T>> createState() =>
      _AdminEntityListMobileVersionState<T>();
}

class _AdminEntityListMobileVersionState<T>
    extends State<AdminEntityListMobileVersion<T>> {
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
    final store = widget.store;
    if (store.loading || store.lastPage) return;

    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      store.loadNextPage();
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    final store = widget.store;
    if (index >= store.list.length) {
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
    return widget.itemBuilder(context, store.list[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final store = widget.store;

        if (store.showProgress) {
          return const Center(child: ListLoadingState());
        } else if (store.error != null && store.list.isEmpty) {
          return Center(
            child: ListErrorState(
                message: store.error ?? widget.errorMessage,
                onRetry: store.refreshData,
                iconColor: CustomColors.copper_spice),
          );
        } else if (store.list.isEmpty) {
          return Center(
            child: ListEmptyState(
                message: widget.emptyMessage,
                iconColor: CustomColors.copper_spice),
          );
        }

        final gridDelegate = widget.gridDelegate;

        return RefreshIndicator(
          onRefresh: store.refreshData,
          color: CustomColors.copper_spice,
          child: gridDelegate != null
              ? GridView.builder(
                  controller: _scrollController,
                  padding: widget.padding,
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: gridDelegate,
                  itemCount: store.itemCount,
                  itemBuilder: _buildItem,
                )
              : ListView.separated(
                  controller: _scrollController,
                  padding: widget.padding,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, __) =>
                      SizedBox(height: widget.listSeparatorHeight),
                  itemCount: store.itemCount,
                  itemBuilder: _buildItem,
                ),
        );
      },
    );
  }
}
