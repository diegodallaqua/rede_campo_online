import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/small_loading_indicator.dart';

/// Lista vertical com paginação por rolagem infinita e pull-to-refresh.
/// Quando [hasMore] é verdadeiro exibe um rodapé de carregamento e dispara
/// [onLoadMore] ao se aproximar do fim da rolagem.
class InfiniteScrollList extends StatefulWidget {
  const InfiniteScrollList({
    super.key,
    required this.itemCount,
    required this.hasMore,
    required this.loading,
    required this.onLoadMore,
    required this.onRefresh,
    required this.itemBuilder,
    this.padding = const EdgeInsets.fromLTRB(16, 20, 16, 110),
    this.separatorSpacing = 10,
  });

  /// Quantidade de itens já carregados (sem contar o rodapé de loading).
  final int itemCount;
  final bool hasMore;
  final bool loading;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry padding;
  final double separatorSpacing;

  @override
  State<InfiniteScrollList> createState() => _InfiniteScrollListState();
}

class _InfiniteScrollListState extends State<InfiniteScrollList> {
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
    if (widget.loading || !widget.hasMore) return;

    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalCount =
        widget.hasMore ? widget.itemCount + 1 : widget.itemCount;

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: CustomColors.copper_spice,
      child: ListView.separated(
        controller: _scrollController,
        padding: widget.padding,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: totalCount,
        separatorBuilder: (_, __) => SizedBox(height: widget.separatorSpacing),
        itemBuilder: (context, index) {
          if (index >= widget.itemCount) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: SmallLoadingIndicator()),
            );
          }
          return widget.itemBuilder(context, index);
        },
      ),
    );
  }
}
