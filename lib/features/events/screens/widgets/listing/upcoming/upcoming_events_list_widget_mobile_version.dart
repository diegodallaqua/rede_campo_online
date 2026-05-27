import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/arrow_button.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/events/event_tile_mobile_version.dart';
import 'package:rede_campo_online/features/events/models/events.dart';
import 'package:rede_campo_online/features/events/models/events_media.dart';
import 'package:rede_campo_online/features/events/stores/events_store.dart';

class UpcomingEventsListWidgetMobileVersion extends StatefulWidget {
  final EventsStore eventsStore;
  final int maxDiscoveredPage;
  final ValueChanged<int> onPageDiscovered;

  const UpcomingEventsListWidgetMobileVersion({
    super.key,
    required this.eventsStore,
    required this.maxDiscoveredPage,
    required this.onPageDiscovered,
  });

  @override
  State<UpcomingEventsListWidgetMobileVersion> createState() =>
      _UpcomingEventsListWidgetMobileVersionState();
}

class _UpcomingEventsListWidgetMobileVersionState
    extends State<UpcomingEventsListWidgetMobileVersion> {
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
          return const ListLoadingState(height: 200);
        }

        if (widget.eventsStore.error != null &&
            widget.eventsStore.list.isEmpty) {
          return ListErrorState(
            message: 'Não foi possível carregar os próximos eventos.',
            onRetry: widget.eventsStore.loadUpcoming,
            iconColor: CustomColors.copper_spice,
            messageColor: CustomColors.vanilla_haze,
            height: 200,
          );
        }

        if (widget.eventsStore.list.isEmpty) {
          return const ListEmptyState(
            message: 'Nenhum próximo evento encontrado.',
            messageColor: CustomColors.vanilla_haze,
            iconColor: CustomColors.concrete_mist,
            height: 200,
          );
        }

        final currentPage = widget.eventsStore.page;
        final isLastPage = widget.eventsStore.lastPage;
        final isLoading = widget.eventsStore.loading;
        final events = widget.eventsStore.list;
        final mediaMap = widget.eventsStore.mediaMap;

        final knownFromStore = isLastPage ? currentPage : currentPage + 1;
        final effectiveMaxPage = widget.maxDiscoveredPage > knownFromStore
            ? widget.maxDiscoveredPage
            : knownFromStore;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGrid(events, mediaMap),
            const SizedBox(height: 16),
            _buildPageCarousel(
              currentPage: currentPage,
              effectiveMaxPage: effectiveMaxPage,
              isLastPage: isLastPage,
              isLoading: isLoading,
            ),
          ],
        );
      },
    );
  }

  Widget _buildGrid(List<Events> events, Map<int, EventMedia> mediaMap) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventTileMobileVersion(
          event: event,
          eventMedia: event.id != null ? mediaMap[event.id] : null,
          pinInfoToBottom: true,
        );
      },
    );
  }

  Widget _buildPageCarousel({
    required int currentPage,
    required int effectiveMaxPage,
    required bool isLastPage,
    required bool isLoading,
  }) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ArrowButton(
              icon: Icons.chevron_left_rounded,
              enabled: !isLoading && currentPage > 1,
              onTap: () => widget.eventsStore.goToPage(currentPage - 1),
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
                onTap: () => widget.eventsStore.goToPage(page),
              );
            }),
            if (!isLastPage)
              ArrowButton(
                icon: Icons.chevron_right_rounded,
                enabled: !isLoading,
                onTap: () => widget.eventsStore.goToPage(currentPage + 1),
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
