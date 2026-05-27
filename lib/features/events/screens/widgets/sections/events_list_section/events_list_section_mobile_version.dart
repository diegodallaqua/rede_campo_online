import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/features/events/stores/events_store.dart';
import '../../listing/upcoming/upcoming_events_list_widget_mobile_version.dart';
import '../../listing/recent/recent_events_list_widget_mobile_version.dart';

class EventsListSectionMobileVersion extends StatefulWidget {
  final EventsStore eventsStore;

  const EventsListSectionMobileVersion({
    super.key,
    required this.eventsStore,
  });

  @override
  State<EventsListSectionMobileVersion> createState() =>
      _EventsListSectionMobileVersionState();
}

class _EventsListSectionMobileVersionState
    extends State<EventsListSectionMobileVersion> {
  int _maxDiscoveredPage = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Próximos Eventos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          UpcomingEventsListWidgetMobileVersion(
            eventsStore: widget.eventsStore,
            maxDiscoveredPage: _maxDiscoveredPage,
            onPageDiscovered: (newMax) {
              if (newMax != _maxDiscoveredPage) {
                setState(() => _maxDiscoveredPage = newMax);
              }
            },
          ),
          const SizedBox(height: 32),
          const Text(
            'Eventos Recentes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          RecentEventsListWidgetMobileVersion(
            eventsStore: widget.eventsStore,
          ),
        ],
      ),
    );
  }
}
