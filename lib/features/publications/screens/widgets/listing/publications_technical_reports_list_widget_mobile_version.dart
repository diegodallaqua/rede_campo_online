import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/technical_reports/technical_reports_tile_mobile_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/arrow_button.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';
import 'package:rede_campo_online/features/technical_reports/stores/technical_reports_store.dart';

class PublicationsTechnicalReportsListWidgetMobileVersion
    extends StatefulWidget {
  final TechnicalReportsStore technicalReportsStore;
  final int maxDiscoveredPage;
  final ValueChanged<int> onPageDiscovered;

  const PublicationsTechnicalReportsListWidgetMobileVersion({
    super.key,
    required this.technicalReportsStore,
    required this.maxDiscoveredPage,
    required this.onPageDiscovered,
  });

  @override
  State<PublicationsTechnicalReportsListWidgetMobileVersion> createState() =>
      _PublicationsTechnicalReportsListWidgetMobileVersionState();
}

class _PublicationsTechnicalReportsListWidgetMobileVersionState
    extends State<PublicationsTechnicalReportsListWidgetMobileVersion> {
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
        if (!widget.technicalReportsStore.loading &&
            widget.technicalReportsStore.list.isNotEmpty) {
          final discovered = widget.technicalReportsStore.page +
              (widget.technicalReportsStore.lastPage ? 0 : 1);
          _notifyPageDiscovered(discovered);
        }

        final showPagination = widget.technicalReportsStore.list.isNotEmpty &&
            (!widget.technicalReportsStore.lastPage ||
                widget.technicalReportsStore.page > 1 ||
                widget.maxDiscoveredPage > 1);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.technicalReportsStore.showProgress)
              const ListLoadingState(color: CustomColors.vanilla_haze)
            else if (widget.technicalReportsStore.error != null &&
                widget.technicalReportsStore.list.isEmpty)
              ListErrorState(
                message: 'Não foi possível carregar os relatórios técnicos.',
                onRetry: widget.technicalReportsStore.refreshData,
                iconColor: CustomColors.copper_spice,
                messageColor: CustomColors.vanilla_haze,
              )
            else if (widget.technicalReportsStore.list.isEmpty)
              const ListEmptyState(
                message: 'Nenhum relatório técnico encontrado.',
                messageColor: CustomColors.vanilla_haze,
                iconColor: CustomColors.concrete_mist,
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
    final reports = widget.technicalReportsStore.list;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: reports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final report = reports[index];
        return TechnicalReportTileMobileVersion(
          technicalReport: report,
          onTap: () => context.push(
            '/publications/technical-reports/${report.publication?.id}',
            extra: report,
          ),
        );
      },
    );
  }

  Widget _buildPageCarousel() {
    final currentPage = widget.technicalReportsStore.page;
    final isLastPage = widget.technicalReportsStore.lastPage;
    final isLoading = widget.technicalReportsStore.loading;

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
              onTap: () =>
                  widget.technicalReportsStore.goToPage(currentPage - 1),
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
                onTap: () => widget.technicalReportsStore.goToPage(page),
              );
            }),
            if (!isLastPage)
              ArrowButton(
                icon: Icons.chevron_right_rounded,
                enabled: !isLoading,
                onTap: () =>
                    widget.technicalReportsStore.goToPage(currentPage + 1),
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
