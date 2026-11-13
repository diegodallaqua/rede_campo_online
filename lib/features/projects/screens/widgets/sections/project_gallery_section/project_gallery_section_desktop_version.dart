import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/section_title.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../stores/project_detail_store.dart';
import '../../listing/gallery/project_gallery_widget_desktop_version.dart';

class ProjectGallerySectionDesktopVersion extends StatelessWidget {
  final ProjectDetailStore projectDetailStore;

  const ProjectGallerySectionDesktopVersion({
    super.key,
    required this.projectDetailStore,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 64, 48, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionTitle(
                title: 'Galeria do Projeto',
                color: CustomColors.fresh_sprout,
              ),
              const SizedBox(height: 32),
              ProjectGalleryWidgetDesktopVersion(
                  projectDetailStore: projectDetailStore),
            ],
          ),
        ),
      ),
    );
  }
}
