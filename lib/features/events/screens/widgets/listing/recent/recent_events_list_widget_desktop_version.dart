import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/events/event_tile_desktop_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';
import 'package:rede_campo_online/features/events/models/events.dart';
import 'package:rede_campo_online/features/events/models/events_media.dart';
import 'package:rede_campo_online/features/events/stores/events_store.dart';

class RecentEventsListWidgetDesktopVersion extends StatelessWidget {
  final EventsStore eventsStore;

  const RecentEventsListWidgetDesktopVersion({
    super.key,
    required this.eventsStore,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (eventsStore.loadingRecent) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: ListLoadingState(color: CustomColors.fresh_sprout),
          );
        }

        if (eventsStore.errorRecent != null &&
            eventsStore.recentList.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: ListErrorState(
              message: 'Não foi possível carregar os eventos recentes.',
              onRetry: eventsStore.loadRecent,
              iconColor: CustomColors.copper_spice,
              messageColor: CustomColors.vanilla_haze,
            ),
          );
        }

        if (eventsStore.recentList.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: ListEmptyState(
              message: 'Nenhum evento recente encontrado.',
              messageColor: CustomColors.vanilla_haze,
              iconColor: CustomColors.concrete_mist,
            ),
          );
        }

        return _buildGrid(eventsStore.recentList, eventsStore.mediaMap);
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
          );
        },
      ),
    );
  }
}
