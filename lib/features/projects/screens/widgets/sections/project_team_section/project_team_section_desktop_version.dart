import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/section_title.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/projects.dart';
import '../../listing/members/project_members_list_widget_desktop_version.dart';

class ProjectTeamSectionDesktopVersion extends StatelessWidget {
  final Projects project;

  const ProjectTeamSectionDesktopVersion({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final members = project.members ?? [];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 64, 48, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionTitle(
                title: 'Equipe do Projeto',
                color: CustomColors.copper_spice,
              ),
              const SizedBox(height: 32),
              ProjectMembersListWidgetDesktopVersion(members: members),
            ],
          ),
        ),
      ),
    );
  }
}
