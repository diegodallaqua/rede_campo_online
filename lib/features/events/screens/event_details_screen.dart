import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/ui/theme/custom_colors.dart';
import '../../../core/ui/widgets/layout/app_scaffold.dart';
import '../../../core/ui/widgets/layout/footer.dart';
import '../models/events.dart';
import '../stores/event_detail_store.dart';
import 'widgets/sections/event_detail_content_section/event_detail_content_section_desktop_version.dart';
import 'widgets/sections/event_detail_content_section/event_detail_content_section_mobile_version.dart';
import 'widgets/sections/event_detail_header_section/event_detail_header_section_desktop_version.dart';
import 'widgets/sections/event_detail_header_section/event_detail_header_section_mobile_version.dart';
import 'widgets/sections/event_detail_location_section/event_detail_location_section_desktop_version.dart';
import 'widgets/sections/event_detail_location_section/event_detail_location_section_mobile_version.dart';
import 'widgets/sections/event_detail_media_carousel_section/event_detail_media_carousel_section_mobile_version.dart';

class EventDetailsScreen extends StatelessWidget {
  final Events event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final eventDetailStore = EventDetailStore(eventId: event.id!);

    return AppScaffold(
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EventDetailHeaderSectionMobileVersion(event: event),
              EventDetailMediaCarouselSectionMobileVersion(
                  eventDetailStore: eventDetailStore),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EventDetailContentSectionMobileVersion(event: event),
                    EventDetailLocationSectionMobileVersion(event: event),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Footer(),
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EventDetailHeaderSectionDesktopVersion(
                event: event,
                eventDetailStore: eventDetailStore,
              ),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EventDetailContentSectionDesktopVersion(event: event),
                    EventDetailLocationSectionDesktopVersion(event: event),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
