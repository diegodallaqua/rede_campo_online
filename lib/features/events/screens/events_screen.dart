import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/layout/footer.dart';
import 'package:rede_campo_online/features/events/screens/widgets/sections/events_header_section/events_header_section_desktop_version.dart';
import 'package:rede_campo_online/features/events/screens/widgets/sections/events_header_section/events_header_section_mobile_version.dart';
import 'package:rede_campo_online/features/events/screens/widgets/sections/events_list_section/events_list_section_desktop_version.dart';
import 'package:rede_campo_online/features/events/screens/widgets/sections/events_list_section/events_list_section_mobile_version.dart';
import 'package:rede_campo_online/features/events/stores/events_store.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../core/ui/widgets/layout/app_scaffold.dart';
import '../../../core/ui/theme/custom_colors.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final largerThanTablet = ResponsiveWrapper.of(context).isLargerThan(TABLET);

    final EventsStore eventsStore =
        EventsStore(pageSize: largerThanTablet ? 4 : 2);

    return AppScaffold(
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const EventsHeaderSectionMobileVersion(),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    EventsListSectionMobileVersion(eventsStore: eventsStore),
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
              const EventsHeaderSectionDesktopVersion(),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    EventsListSectionDesktopVersion(eventsStore: eventsStore),
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
