import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/layout/footer.dart';
import 'package:rede_campo_online/features/projects/stores/projects_store.dart';
import 'package:rede_campo_online/features/projects/widgets/sections/projects_header_section_desktop_version.dart';
import 'package:rede_campo_online/features/projects/widgets/sections/projects_header_section_mobile_version.dart';
import 'package:rede_campo_online/features/projects/widgets/sections/projects_list_section_mobile_version.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../core/ui/layout/app_scaffold.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../widgets/sections/projects_list_section_desktop_version.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectsStore projectsStoreMobile = ProjectsStore();
    final ProjectsStore projectsStoreDesktop = ProjectsStore(pageSize: 4);

    return AppScaffold(
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProjectsHeaderSectionMobileVersion(),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    ProjectsListSectionMobileVersion(
                        projectsStore: projectsStoreMobile),
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
              const ProjectsHeaderSectionDesktopVersion(),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    ProjectsListSectionDesktopVersion(
                        projectsStore: projectsStoreDesktop),
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
