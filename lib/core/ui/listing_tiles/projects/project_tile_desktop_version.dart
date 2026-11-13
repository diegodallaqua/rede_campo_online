import 'package:flutter/material.dart';
import '../../../../features/projects/models/project_media.dart';
import '../../../../features/projects/models/projects.dart';
import '../../theme/custom_colors.dart';
import '../../theme/custom_text_styles.dart';
import '../tile_card.dart';

class ProjectTileDesktopVersion extends StatelessWidget {
  final Projects project;
  final ProjectMedia? projectMedia;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final bool isAdmin;

  const ProjectTileDesktopVersion({
    super.key,
    required this.project,
    this.projectMedia,
    this.onTap,
    this.margin,
    this.isAdmin = false,
  });

  /// Altura que as listagens reservam para cada card.
  static const double height = 340.0;
  static const double _coverHeight = 160.0;

  @override
  Widget build(BuildContext context) {
    final description = project.description?.trim() ?? '';

    return TileCard(
      margin: margin,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TileCover(imageUrl: projectMedia?.media, height: _coverHeight),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name ?? '-',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.cardTitleDesktop.copyWith(
                      color: CustomColors.pine_shadow,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.meta.copyWith(
                      color: CustomColors.midnight_slate,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isAdmin) const TileReadMore(),
        ],
      ),
    );
  }
}
