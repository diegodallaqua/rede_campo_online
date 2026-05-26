import 'package:flutter/material.dart';

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
              Row(
                children: [
                  const Text(
                    'Galeria do Projeto',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.fresh_sprout,
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
                            CustomColors.fresh_sprout.withOpacity(0.4),
                            CustomColors.fresh_sprout.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
