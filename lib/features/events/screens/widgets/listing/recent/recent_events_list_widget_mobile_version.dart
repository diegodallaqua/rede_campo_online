import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/events/event_tile_mobile_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';
import 'package:rede_campo_online/features/events/models/events.dart';
import 'package:rede_campo_online/features/events/models/events_media.dart';
import 'package:rede_campo_online/features/events/stores/events_store.dart';

class RecentEventsListWidgetMobileVersion extends StatefulWidget {
  final EventsStore eventsStore;

  static const double _separatorWidth = 12.0;
  static const double _tileAspectRatio = 0.72;

  const RecentEventsListWidgetMobileVersion({
    super.key,
    required this.eventsStore,
  });

  @override
  State<RecentEventsListWidgetMobileVersion> createState() =>
      _RecentEventsListWidgetMobileVersionState();
}

class _RecentEventsListWidgetMobileVersionState
    extends State<RecentEventsListWidgetMobileVersion> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (widget.eventsStore.loadingRecent) {
          return const ListLoadingState(height: 200);
        }

        if (widget.eventsStore.errorRecent != null &&
            widget.eventsStore.recentList.isEmpty) {
          return ListErrorState(
            message: 'Não foi possível carregar os eventos recentes.',
            onRetry: widget.eventsStore.loadRecent,
            iconColor: CustomColors.copper_spice,
            messageColor: CustomColors.vanilla_haze,
            height: 200,
          );
        }

        if (widget.eventsStore.recentList.isEmpty) {
          return const ListEmptyState(
            message: 'Nenhum evento recente encontrado.',
            messageColor: CustomColors.vanilla_haze,
            iconColor: CustomColors.concrete_mist,
            height: 200,
          );
        }

        return _buildCarousel(
          widget.eventsStore.recentList,
          widget.eventsStore.mediaMap,
        );
      },
    );
  }

  Widget _buildCarousel(List<Events> events, Map<int, EventMedia> mediaMap) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double tileWidth = (constraints.maxWidth -
                RecentEventsListWidgetMobileVersion._separatorWidth) /
            2;
        final double tileHeight =
            tileWidth / RecentEventsListWidgetMobileVersion._tileAspectRatio;

        return Scrollbar(
          thumbVisibility: true,
          controller: _scrollController,
          child: SizedBox(
            height: tileHeight,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              itemCount: events.length,
              separatorBuilder: (_, __) => const SizedBox(
                width: RecentEventsListWidgetMobileVersion._separatorWidth,
              ),
              itemBuilder: (context, index) {
                final event = events[index];
                return SizedBox(
                  width: tileWidth,
                  child: EventTileMobileVersion(
                    event: event,
                    eventMedia: event.id != null ? mediaMap[event.id] : null,
                    pinInfoToBottom: true,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
