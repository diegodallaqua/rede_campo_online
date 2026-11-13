import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/section_title.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../stores/project_detail_store.dart';
import '../../listing/publications/project_publications_list_widget_desktop_version.dart';

class ProjectPublicationsSectionDesktopVersion extends StatelessWidget {
  final ProjectDetailStore projectDetailStore;

  const ProjectPublicationsSectionDesktopVersion({
    super.key,
    required this.projectDetailStore,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 0, 48, 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionTitle(
                title: 'Publicações Vinculadas',
                color: CustomColors.fresh_sprout,
              ),
              const SizedBox(height: 32),
              ProjectPublicationsListWidgetDesktopVersion(
                  projectDetailStore: projectDetailStore),
            ],
          ),
        ),
      ),
    );
  }
}
