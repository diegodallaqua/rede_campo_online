import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/academic_works/academic_work_tile_desktop_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/arrow_button.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';

import '../../../../../academic_works/stores/academic_work_store.dart';

class PublicationsAcademicWorksListWidgetDesktopVersion extends StatefulWidget {
  final AcademicWorkStore academicWorkStore;
  final int maxDiscoveredPage;
  final ValueChanged<int> onPageDiscovered;

  const PublicationsAcademicWorksListWidgetDesktopVersion({
    super.key,
    required this.academicWorkStore,
    required this.maxDiscoveredPage,
    required this.onPageDiscovered,
  });

  @override
  State<PublicationsAcademicWorksListWidgetDesktopVersion> createState() =>
      _PublicationsAcademicWorksListWidgetDesktopVersionState();
}

class _PublicationsAcademicWorksListWidgetDesktopVersionState
    extends State<PublicationsAcademicWorksListWidgetDesktopVersion> {
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
        if (!widget.academicWorkStore.loading &&
            widget.academicWorkStore.list.isNotEmpty) {
          final discovered = widget.academicWorkStore.page +
              (widget.academicWorkStore.lastPage ? 0 : 1);
          _notifyPageDiscovered(discovered);
        }

        final showPagination = widget.academicWorkStore.list.isNotEmpty &&
            (!widget.academicWorkStore.lastPage ||
                widget.academicWorkStore.page > 1 ||
                widget.maxDiscoveredPage > 1);

        if (widget.academicWorkStore.showProgress) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: ListLoadingState(color: CustomColors.vanilla_haze),
          );
        } else if (widget.academicWorkStore.error != null &&
            widget.academicWorkStore.list.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: ListErrorState(
              message: 'Não foi possível carregar os trabalhos acadêmicos.',
              onRetry: widget.academicWorkStore.refreshData,
              iconColor: CustomColors.copper_spice,
              messageColor: CustomColors.vanilla_haze,
            ),
          );
        } else if (widget.academicWorkStore.list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: ListEmptyState(
              message: 'Nenhum trabalho acadêmico encontrado.',
              messageColor: CustomColors.vanilla_haze,
              iconColor: CustomColors.concrete_mist,
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
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildGrid() {
    final academicWorks = widget.academicWorkStore.list;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 180,
        ),
        itemCount: academicWorks.length,
        itemBuilder: (context, index) {
          final academicWork = academicWorks[index];
          return AcademicWorkTileDesktopVersion(
            academicWork: academicWork,
            onTap: () => context.push(
              '/publications/academic-works/${academicWork.publication?.id}',
              extra: academicWork,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPagination() {
    final currentPage = widget.academicWorkStore.page;
    final isLastPage = widget.academicWorkStore.lastPage;
    final isLoading = widget.academicWorkStore.loading;

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
            onTap: () => widget.academicWorkStore.goToPage(currentPage - 1),
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
              onTap: () => widget.academicWorkStore.goToPage(page),
            );
          }),
          if (!isLastPage)
            ArrowButton(
              icon: Icons.chevron_right_rounded,
              enabled: !isLoading,
              onTap: () => widget.academicWorkStore.goToPage(currentPage + 1),
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
