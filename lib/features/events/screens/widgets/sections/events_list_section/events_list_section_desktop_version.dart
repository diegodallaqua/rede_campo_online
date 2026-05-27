import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/features/events/stores/events_store.dart';
import '../../listing/upcoming/upcoming_events_list_widget_desktop_version.dart';
import '../../listing/recent/recent_events_list_widget_desktop_version.dart';

class EventsListSectionDesktopVersion extends StatefulWidget {
  final EventsStore eventsStore;

  const EventsListSectionDesktopVersion({
    super.key,
    required this.eventsStore,
  });

  @override
  State<EventsListSectionDesktopVersion> createState() =>
      _EventsListSectionDesktopVersionState();
}

class _EventsListSectionDesktopVersionState
    extends State<EventsListSectionDesktopVersion> {
  int _maxDiscoveredPage = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Próximos Eventos'),
              const SizedBox(height: 20),
              UpcomingEventsListWidgetDesktopVersion(
                eventsStore: widget.eventsStore,
                maxDiscoveredPage: _maxDiscoveredPage,
                onPageDiscovered: (newMax) {
                  if (newMax != _maxDiscoveredPage) {
                    setState(() => _maxDiscoveredPage = newMax);
                  }
                },
              ),
              const SizedBox(height: 48),
              _buildSectionTitle('Eventos Recentes'),
              const SizedBox(height: 20),
              RecentEventsListWidgetDesktopVersion(
                eventsStore: widget.eventsStore,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 64,
            height: 3,
            decoration: BoxDecoration(
              color: CustomColors.fresh_sprout,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
