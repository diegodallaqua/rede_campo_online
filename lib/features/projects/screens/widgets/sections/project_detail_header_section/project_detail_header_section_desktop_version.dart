import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/utils/placeholders.dart';
import '../../../../models/projects.dart';
import '../../../../stores/project_detail_store.dart';

class ProjectDetailHeaderSectionDesktopVersion extends StatelessWidget {
  final Projects project;
  final ProjectDetailStore projectDetailStore;

  const ProjectDetailHeaderSectionDesktopVersion({
    super.key,
    required this.project,
    required this.projectDetailStore,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.vanilla_haze,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (project.projectType?.name != null) ...[
                        Text(
                          project.projectType!.name!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: CustomColors.copper_spice,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Text(
                        project.name ?? '-',
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          color: CustomColors.midnight_slate,
                          fontFamily: 'RobotoSlab',
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 56,
                        height: 4,
                        decoration: BoxDecoration(
                          color: CustomColors.copper_spice,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      if (project.begin_date != null ||
                          project.end_date != null) ...[
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 24,
                          runSpacing: 8,
                          children: [
                            if (project.begin_date != null)
                              _DateChip(
                                icon: Icons.calendar_today_outlined,
                                label:
                                    'Início: ${_formatDate(project.begin_date)}',
                              ),
                            if (project.end_date != null)
                              _DateChip(
                                icon: Icons.event_available_outlined,
                                label:
                                    'Término: ${_formatDate(project.end_date)}',
                              ),
                          ],
                        ),
                      ],
                      if (project.research_areas?.isNotEmpty == true) ...[
                        const SizedBox(height: 20),
                        _ResearchAreaChips(
                          areas: project.research_areas!
                              .map((a) => a.name ?? '')
                              .where((n) => n.isNotEmpty)
                              .toList(),
                        ),
                      ],
                      if (project.description?.isNotEmpty == true) ...[
                        const SizedBox(height: 28),
                        Text(
                          project.description!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: CustomColors.pine_shadow,
                            height: 1.8,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 64),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StatusBadge(isActive: project.status ?? false),
                      const SizedBox(height: 20),
                      Observer(
                        builder: (context) {
                          final media = projectDetailStore.coverMedia;
                          final hasImage = media?.media?.isNotEmpty == true;
                          return AspectRatio(
                            aspectRatio: 4 / 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: hasImage
                                  ? Image.network(
                                      media!.media!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const ImagePlaceholder(),
                                    )
                                  : const ImagePlaceholder(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DateChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: CustomColors.copper_spice),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: CustomColors.pine_shadow,
          ),
        ),
      ],
    );
  }
}

class _ResearchAreaChips extends StatelessWidget {
  final List<String> areas;

  const _ResearchAreaChips({required this.areas});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: areas.map((area) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: CustomColors.copper_spice.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: CustomColors.copper_spice.withOpacity(0.4),
            ),
          ),
          child: Text(
            area,
            style: const TextStyle(
              fontSize: 12,
              color: CustomColors.copper_spice,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isActive;

  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive
              ? CustomColors.pine_shadow.withOpacity(0.15)
              : CustomColors.concrete_mist.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? CustomColors.pine_shadow
                : CustomColors.concrete_mist,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive
                    ? CustomColors.pine_shadow
                    : CustomColors.concrete_mist,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isActive ? 'Em andamento' : 'Encerrado',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? CustomColors.pine_shadow
                    : CustomColors.pine_shadow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
