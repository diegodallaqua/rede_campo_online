import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../stores/project_detail_store.dart';
import '../../listing/events/project_events_list_widget_mobile_version.dart';

class ProjectEventsSectionMobileVersion extends StatelessWidget {
  final ProjectDetailStore projectDetailStore;

  const ProjectEventsSectionMobileVersion({
    super.key,
    required this.projectDetailStore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 28),
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
          ProjectEventsListWidgetMobileVersion(
              projectDetailStore: projectDetailStore),
        ],
      ),
    );
  }
}
