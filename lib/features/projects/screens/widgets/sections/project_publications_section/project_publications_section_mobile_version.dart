import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/section_title.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../stores/project_detail_store.dart';
import '../../listing/publications/project_publications_list_widget_mobile_version.dart';

class ProjectPublicationsSectionMobileVersion extends StatelessWidget {
  final ProjectDetailStore projectDetailStore;

  const ProjectPublicationsSectionMobileVersion({
    super.key,
    required this.projectDetailStore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SectionTitle.mobile(
              title: 'Publicações Vinculadas',
              color: CustomColors.fresh_sprout,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ProjectPublicationsListWidgetMobileVersion(
                projectDetailStore: projectDetailStore),
          ),
        ],
      ),
    );
  }
}
