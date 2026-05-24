import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/book_chapters/book_chapter_tile_mobile_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/arrow_button.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';
import 'package:rede_campo_online/features/book_chapters/stores/book_chapters_store.dart';

class PublicationsBookChaptersListWidgetMobileVersion extends StatefulWidget {
  final BookChaptersStore bookChaptersStore;
  final int maxDiscoveredPage;
  final ValueChanged<int> onPageDiscovered;

  const PublicationsBookChaptersListWidgetMobileVersion({
    super.key,
    required this.bookChaptersStore,
    required this.maxDiscoveredPage,
    required this.onPageDiscovered,
  });

  @override
  State<PublicationsBookChaptersListWidgetMobileVersion> createState() =>
      _PublicationsBookChaptersListWidgetMobileVersionState();
}

class _PublicationsBookChaptersListWidgetMobileVersionState
    extends State<PublicationsBookChaptersListWidgetMobileVersion> {
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
        if (!widget.bookChaptersStore.loading &&
            widget.bookChaptersStore.list.isNotEmpty) {
          final discovered = widget.bookChaptersStore.page +
              (widget.bookChaptersStore.lastPage ? 0 : 1);
          _notifyPageDiscovered(discovered);
        }

        final showPagination = widget.bookChaptersStore.list.isNotEmpty &&
            (!widget.bookChaptersStore.lastPage ||
                widget.bookChaptersStore.page > 1 ||
                widget.maxDiscoveredPage > 1);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.bookChaptersStore.showProgress)
              const ListLoadingState()
            else if (widget.bookChaptersStore.error != null &&
                widget.bookChaptersStore.list.isEmpty)
              ListErrorState(
                message: 'Não foi possível carregar os capítulos de livros.',
                onRetry: widget.bookChaptersStore.refreshData,
                iconColor: CustomColors.copper_spice,
                messageColor: CustomColors.pine_shadow,
              )
            else if (widget.bookChaptersStore.list.isEmpty)
              const ListEmptyState(
                message: 'Nenhum capítulo de livro encontrado.',
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
    final chapters = widget.bookChaptersStore.list;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: chapters.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return BookChapterTileMobileVersion(
          bookChapter: chapters[index],
        );
      },
    );
  }

  Widget _buildPageCarousel() {
    final currentPage = widget.bookChaptersStore.page;
    final isLastPage = widget.bookChaptersStore.lastPage;
    final isLoading = widget.bookChaptersStore.loading;

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
              onTap: () => widget.bookChaptersStore.goToPage(currentPage - 1),
              iconColor: CustomColors.copper_spice,
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
                onTap: () => widget.bookChaptersStore.goToPage(page),
              );
            }),
            if (!isLastPage)
              ArrowButton(
                icon: Icons.chevron_right_rounded,
                enabled: !isLoading,
                onTap: () => widget.bookChaptersStore.goToPage(currentPage + 1),
                iconColor: CustomColors.copper_spice,
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
            color: isActive ? CustomColors.honey_cream : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? CustomColors.honey_cream
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
                    ? CustomColors.copper_spice
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
