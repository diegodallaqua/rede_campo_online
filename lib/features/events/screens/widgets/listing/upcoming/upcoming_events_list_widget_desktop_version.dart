import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/events/event_tile_desktop_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/arrow_button.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';
import 'package:rede_campo_online/features/events/models/events.dart';
import 'package:rede_campo_online/features/events/models/events_media.dart';
import 'package:rede_campo_online/features/events/stores/events_store.dart';

class UpcomingEventsListWidgetDesktopVersion extends StatefulWidget {
  final EventsStore eventsStore;
  final int maxDiscoveredPage;
  final ValueChanged<int> onPageDiscovered;

  const UpcomingEventsListWidgetDesktopVersion({
    super.key,
    required this.eventsStore,
    required this.maxDiscoveredPage,
    required this.onPageDiscovered,
  });

  @override
  State<UpcomingEventsListWidgetDesktopVersion> createState() =>
      _UpcomingEventsListWidgetDesktopVersionState();
}

class _UpcomingEventsListWidgetDesktopVersionState
    extends State<UpcomingEventsListWidgetDesktopVersion> {
  void _notifyPageDiscovered(int discovered) {
    final shouldGrow = discovered > widget.maxDiscoveredPage;
    final shouldShrink =
        widget.eventsStore.lastPage && discovered < widget.maxDiscoveredPage;
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
        if (!widget.eventsStore.loading && widget.eventsStore.list.isNotEmpty) {
          final discovered =
              widget.eventsStore.page + (widget.eventsStore.lastPage ? 0 : 1);
          _notifyPageDiscovered(discovered);
        }

        if (widget.eventsStore.showProgress) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: ListLoadingState(color: CustomColors.fresh_sprout),
          );
        }

        if (widget.eventsStore.error != null &&
            widget.eventsStore.list.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: ListErrorState(
              message: 'Não foi possível carregar os próximos eventos.',
              onRetry: widget.eventsStore.loadUpcoming,
              iconColor: CustomColors.copper_spice,
              messageColor: CustomColors.vanilla_haze,
            ),
          );
        }

        if (widget.eventsStore.list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: ListEmptyState(
              message: 'Nenhum próximo evento encontrado.',
              messageColor: CustomColors.vanilla_haze,
              iconColor: CustomColors.concrete_mist,
            ),
          );
        }

        final currentPage = widget.eventsStore.page;
        final isLastPage = widget.eventsStore.lastPage;
        final isLoading = widget.eventsStore.loading;
        final events = widget.eventsStore.list;
        final mediaMap = widget.eventsStore.mediaMap;

        final showPagination =
            !isLastPage || currentPage > 1 || widget.maxDiscoveredPage > 1;

        final knownFromStore = isLastPage ? currentPage : currentPage + 1;
        final effectiveMaxPage = widget.maxDiscoveredPage > knownFromStore
            ? widget.maxDiscoveredPage
            : knownFromStore;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGrid(events, mediaMap),
            if (showPagination) ...[
              const SizedBox(height: 24),
              _buildPagination(
                currentPage: currentPage,
                effectiveMaxPage: effectiveMaxPage,
                isLastPage: isLastPage,
                isLoading: isLoading,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildGrid(List<Events> events, Map<int, EventMedia> mediaMap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 330,
        ),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return EventTileDesktopVersion(
            event: event,
            eventMedia: event.id != null ? mediaMap[event.id] : null,
            onTap: () => context.push(
              '/events/${event.id}',
              extra: event,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPagination({
    required int currentPage,
    required int effectiveMaxPage,
    required bool isLastPage,
    required bool isLoading,
  }) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ArrowButton(
            icon: Icons.chevron_left_rounded,
            enabled: !isLoading && currentPage > 1,
            onTap: () => widget.eventsStore.goToPage(currentPage - 1),
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
              onTap: () => widget.eventsStore.goToPage(page),
            );
          }),
          if (!isLastPage)
            ArrowButton(
              icon: Icons.chevron_right_rounded,
              enabled: !isLoading,
              onTap: () => widget.eventsStore.goToPage(currentPage + 1),
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
