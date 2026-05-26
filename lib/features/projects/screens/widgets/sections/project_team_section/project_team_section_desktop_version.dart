import 'package:flutter/material.dart';

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
              Row(
                children: [
                  const Text(
                    'Equipe do Projeto',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.copper_spice,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            CustomColors.copper_spice.withOpacity(0.4),
                            CustomColors.copper_spice.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
