import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../core/stores/client_paged_store.dart';
import '../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../core/ui/widgets/arrow_button.dart';
import '../../../../../core/ui/widgets/list_empty_state.dart';
import '../../../../../core/ui/widgets/list_error_state.dart';
import '../../../../../core/ui/widgets/list_loading_state.dart';

/// Listagem paginada de um tipo de publicação, com estados de carregamento,
/// erro e vazio e paginação numerada.
///
/// Com [gridDelegate] usa grade (desktop); sem ele, lista vertical (mobile).
/// [onDarkBackground] ajusta as cores para seções de fundo escuro.
class PublicationsPagedList<T> extends StatefulWidget {
  final ClientPagedStore<T> store;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String errorMessage;
  final String emptyMessage;
  final bool onDarkBackground;
  final SliverGridDelegate? gridDelegate;

  /// Maior página já descoberta, mantida pela seção entre trocas de página.
  final int maxDiscoveredPage;
  final ValueChanged<int> onPageDiscovered;

  const PublicationsPagedList({
    super.key,
    required this.store,
    required this.itemBuilder,
    required this.errorMessage,
    required this.emptyMessage,
    required this.maxDiscoveredPage,
    required this.onPageDiscovered,
    this.onDarkBackground = false,
    this.gridDelegate,
  });

  @override
  State<PublicationsPagedList<T>> createState() =>
      _PublicationsPagedListState<T>();
}

class _PublicationsPagedListState<T> extends State<PublicationsPagedList<T>> {
  ClientPagedStore<T> get _store => widget.store;

  bool get _isDesktop => widget.gridDelegate != null;

  void _notifyPageDiscovered(int discovered) {
    if (discovered > widget.maxDiscoveredPage) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        widget.onPageDiscovered(discovered);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (!_store.loading && _store.list.isNotEmpty) {
          _notifyPageDiscovered(_store.page + (_store.lastPage ? 0 : 1));
        }

        final showPagination = _store.list.isNotEmpty &&
            (!_store.lastPage ||
                _store.page > 1 ||
                widget.maxDiscoveredPage > 1);

        final state = _buildState();
        if (_isDesktop) {
          if (state != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: state,
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: _buildItems(),
              ),
              if (showPagination) ...[
                const SizedBox(height: 24),
                _buildPagination(),
              ],
              const SizedBox(height: 8),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            state ?? _buildItems(),
            if (showPagination) ...[
              const SizedBox(height: 24),
              _buildPagination(),
            ],
          ],
        );
      },
    );
  }

  /// Carregamento, erro ou vazio; null quando há itens para exibir.
  Widget? _buildState() {
    final dark = widget.onDarkBackground;
    if (_store.showProgress) {
      return dark
          ? const ListLoadingState(color: CustomColors.vanilla_haze)
          : const ListLoadingState();
    }
    if (_store.error != null && _store.list.isEmpty) {
      return ListErrorState(
        message: widget.errorMessage,
        onRetry: _store.refreshData,
        iconColor: CustomColors.copper_spice,
        messageColor:
            dark ? CustomColors.vanilla_haze : CustomColors.pine_shadow,
      );
    }
    if (_store.list.isEmpty) {
      return dark
          ? ListEmptyState(
              message: widget.emptyMessage,
              messageColor: CustomColors.vanilla_haze,
              iconColor: CustomColors.concrete_mist,
            )
          : ListEmptyState(message: widget.emptyMessage);
    }
    return null;
  }

  Widget _buildItems() {
    final items = _store.list;
    final gridDelegate = widget.gridDelegate;
    if (gridDelegate != null) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: gridDelegate,
        itemCount: items.length,
        itemBuilder: (context, index) =>
            widget.itemBuilder(context, items[index]),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) =>
          widget.itemBuilder(context, items[index]),
    );
  }

  Widget _buildPagination() {
    final palette = _PaginationPalette.of(
      desktop: _isDesktop,
      dark: widget.onDarkBackground,
    );
    final currentPage = _store.page;
    final isLastPage = _store.lastPage;
    final isLoading = _store.loading;

    final knownFromStore = isLastPage ? currentPage : currentPage + 1;
    final effectiveMaxPage = widget.maxDiscoveredPage > knownFromStore
        ? widget.maxDiscoveredPage
        : knownFromStore;

    Widget arrow(IconData icon, bool enabled, int targetPage) => ArrowButton(
          icon: icon,
          enabled: enabled,
          onTap: () => _store.goToPage(targetPage),
          iconColor: palette.arrowIcon,
          disabledIconColor: CustomColors.concrete_mist,
          backgroundColor: palette.arrowBackground,
          iconSize: 18,
          borderRadius: 12,
          border: palette.arrowBorder,
          fixedSize: _isDesktop ? 36 : 33,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          useRipple: false,
        );

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        arrow(Icons.chevron_left_rounded, !isLoading && currentPage > 1,
            currentPage - 1),
        ...List.generate(effectiveMaxPage, (index) {
          final page = index + 1;
          return _PageNumberButton(
            page: page,
            isActive: page == currentPage,
            enabled: !isLoading,
            palette: palette,
            onTap: () => _store.goToPage(page),
          );
        }),
        if (!isLastPage)
          arrow(Icons.chevron_right_rounded, !isLoading, currentPage + 1),
      ],
    );

    return Center(
      child: _isDesktop
          ? row
          : SingleChildScrollView(scrollDirection: Axis.horizontal, child: row),
    );
  }
}

/// Cores da paginação conforme o layout e o fundo da seção.
class _PaginationPalette {
  final Color arrowIcon;
  final Color arrowBackground;
  final Border? arrowBorder;
  final Color activeFill;
  final Color inactiveFill;
  final Color inactiveBorder;
  final Color Function(bool isActive, bool enabled) pageText;

  const _PaginationPalette({
    required this.arrowIcon,
    required this.arrowBackground,
    required this.arrowBorder,
    required this.activeFill,
    required this.inactiveFill,
    required this.inactiveBorder,
    required this.pageText,
  });

  factory _PaginationPalette.of({required bool desktop, required bool dark}) {
    final lightBorder = Border.all(color: CustomColors.concrete_mist);
    Color enabledText(bool enabled) =>
        enabled ? CustomColors.midnight_slate : CustomColors.concrete_mist;

    if (desktop && dark) {
      return _PaginationPalette(
        arrowIcon: CustomColors.vanilla_haze,
        arrowBackground: Colors.white.withOpacity(0.1),
        arrowBorder: null,
        activeFill: CustomColors.fresh_sprout,
        inactiveFill: CustomColors.vanilla_haze.withOpacity(0.15),
        inactiveBorder: CustomColors.vanilla_haze.withOpacity(0.3),
        pageText: (_, enabled) =>
            enabled ? CustomColors.vanilla_haze : CustomColors.concrete_mist,
      );
    }
    if (dark) {
      return _PaginationPalette(
        arrowIcon: CustomColors.midnight_slate,
        arrowBackground: Colors.white,
        arrowBorder: lightBorder,
        activeFill: CustomColors.fresh_sprout,
        inactiveFill: Colors.white,
        inactiveBorder: CustomColors.concrete_mist,
        pageText: (isActive, enabled) =>
            isActive ? Colors.white : enabledText(enabled),
      );
    }
    return _PaginationPalette(
      arrowIcon: CustomColors.copper_spice,
      arrowBackground: Colors.white,
      arrowBorder: lightBorder,
      activeFill: CustomColors.honey_cream,
      inactiveFill: Colors.white,
      inactiveBorder: CustomColors.concrete_mist,
      pageText: (isActive, enabled) =>
          isActive ? CustomColors.copper_spice : enabledText(enabled),
    );
  }
}

class _PageNumberButton extends StatelessWidget {
  final int page;
  final bool isActive;
  final bool enabled;
  final _PaginationPalette palette;
  final VoidCallback onTap;

  const _PageNumberButton({
    required this.page,
    required this.isActive,
    required this.enabled,
    required this.palette,
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
            color: isActive ? palette.activeFill : palette.inactiveFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? palette.activeFill : palette.inactiveBorder,
            ),
          ),
          child: Center(
            child: Text(
              '$page',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                color: palette.pageText(isActive, enabled),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
