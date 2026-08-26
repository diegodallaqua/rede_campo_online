import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/ui/widgets/layout/app_scaffold.dart';
import '../../../core/ui/widgets/layout/footer.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../models/projects.dart';
import '../stores/project_detail_store.dart';
import 'widgets/sections/project_detail_header_section/project_detail_header_section_desktop_version.dart';
import 'widgets/sections/project_detail_header_section/project_detail_header_section_mobile_version.dart';
import 'widgets/sections/project_events_section/project_events_section_desktop_version.dart';
import 'widgets/sections/project_events_section/project_events_section_mobile_version.dart';
import 'widgets/sections/project_publications_section/project_publications_section_desktop_version.dart';
import 'widgets/sections/project_publications_section/project_publications_section_mobile_version.dart';
import 'widgets/sections/project_gallery_section/project_gallery_section_desktop_version.dart';
import 'widgets/sections/project_gallery_section/project_gallery_section_mobile_version.dart';
import 'widgets/sections/project_team_section/project_team_section_desktop_version.dart';
import 'widgets/sections/project_team_section/project_team_section_mobile_version.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Projects project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final projectDetailStore = ProjectDetailStore(projectId: project.id!);

    return AppScaffold(
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProjectDetailHeaderSectionMobileVersion(project: project),
              ProjectGallerySectionMobileVersion(
                  projectDetailStore: projectDetailStore),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProjectEventsSectionMobileVersion(
                        projectDetailStore: projectDetailStore),
                    ProjectPublicationsSectionMobileVersion(
                        projectDetailStore: projectDetailStore),
                    ProjectTeamSectionMobileVersion(project: project),
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
              ProjectDetailHeaderSectionDesktopVersion(
                  project: project, projectDetailStore: projectDetailStore),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProjectGallerySectionDesktopVersion(
                        projectDetailStore: projectDetailStore),
                    ProjectEventsSectionDesktopVersion(
                        projectDetailStore: projectDetailStore),
                    ProjectPublicationsSectionDesktopVersion(
                        projectDetailStore: projectDetailStore),
                  ],
                ),
              ),
              ProjectTeamSectionDesktopVersion(project: project),
              const SizedBox(height: 16),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
