import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/projects.dart';
import '../../listing/project_members_list_widget_mobile_version.dart';

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
          const Text(
            'Equipe do Projeto',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ProjectMembersListWidgetMobileVersion(members: members),
        ],
      ),
    );
  }
}
