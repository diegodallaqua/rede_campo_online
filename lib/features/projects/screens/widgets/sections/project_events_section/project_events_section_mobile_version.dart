import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/section_title.dart';

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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SectionTitle.mobile(
              title: 'Próximos Eventos',
              color: CustomColors.fresh_sprout,
            ),
          ),
          const SizedBox(height: 16),
          ProjectEventsListWidgetMobileVersion(
              projectDetailStore: projectDetailStore),
        ],
      ),
    );
  }
}
