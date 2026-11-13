import 'package:flutter/material.dart';
import '../../../../features/projects/models/project_media.dart';
import '../../../../features/projects/models/projects.dart';
import '../../theme/custom_colors.dart';
import '../../theme/custom_text_styles.dart';
import '../tile_card.dart';

class ProjectTileMobileVersion extends StatelessWidget {
  final Projects project;
  final ProjectMedia? projectMedia;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final bool isAdmin;

  const ProjectTileMobileVersion({
    super.key,
    required this.project,
    this.projectMedia,
    this.onTap,
    this.margin,
    this.isAdmin = false,
  });

  static const double _coverHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    final description = project.description?.trim() ?? '';

    return TileCard(
      margin: margin,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TileCover(imageUrl: projectMedia?.media, height: _coverHeight),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name ?? '-',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.cardTitleMobile.copyWith(
                    color: CustomColors.pine_shadow,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.meta.copyWith(
                      color: CustomColors.midnight_slate,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!isAdmin) const TileReadMore(),
        ],
      ),
    );
  }
}
