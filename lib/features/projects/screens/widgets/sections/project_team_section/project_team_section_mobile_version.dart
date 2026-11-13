import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/section_title.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/projects.dart';
import '../../listing/members/project_members_list_widget_mobile_version.dart';

class ProjectTeamSectionMobileVersion extends StatelessWidget {
  final Projects project;

  const ProjectTeamSectionMobileVersion({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final members = project.members ?? [];

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SectionTitle.mobile(
              title: 'Equipe do Projeto',
              color: CustomColors.fresh_sprout,
            ),
          ),
          const SizedBox(height: 16),
          ProjectMembersListWidgetMobileVersion(members: members),
        ],
      ),
    );
  }
}
