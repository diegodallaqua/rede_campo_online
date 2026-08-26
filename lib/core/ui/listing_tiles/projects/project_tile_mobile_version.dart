import 'package:flutter/material.dart';
import '../../../../features/projects/models/project_media.dart';
import '../../../../features/projects/models/projects.dart';
import '../../../utils/placeholders.dart';
import '../../theme/custom_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.sizeOf(context).width * 0.9;
    const double coverHeight = 120.0;
    const double borderRadius = 12.0;
    const double titleFontSize = 14.0;
    const double textFontSize = 12.0;

    final content = Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: CustomColors.vanilla_haze,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
            child: SizedBox(
              height: coverHeight,
              child: projectMedia != null &&
                      projectMedia!.media != null &&
                      projectMedia!.media!.isNotEmpty
                  ? Image.network(
                      projectMedia!.media!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ImagePlaceholder(),
                    )
                  : const ImagePlaceholder(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name ?? '-',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.pine_shadow,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: textFontSize,
                      color: CustomColors.pine_shadow,
                      height: 1.35,
                    ),
                    children: [
                      TextSpan(
                        text: project.description,
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                if (!isAdmin) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.copper_spice,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'SAIBA MAIS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    return Container(
      margin: margin,
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: onTap,
                child: content,
              ),
            ),
    );
  }
}
