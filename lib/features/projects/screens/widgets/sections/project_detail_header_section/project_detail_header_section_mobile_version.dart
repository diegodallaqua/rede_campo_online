import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/projects.dart';

class ProjectDetailHeaderSectionMobileVersion extends StatelessWidget {
  final Projects project;

  const ProjectDetailHeaderSectionMobileVersion({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.vanilla_haze,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (project.projectType?.name != null) ...[
            Text(
              project.projectType!.name!,
              style: const TextStyle(
                fontSize: 14,
                color: CustomColors.pine_shadow,
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            project.name ?? '-',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: CustomColors.copper_spice,
              fontFamily: 'RobotoSlab',
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          if (_hasDateInfo) ...[
            const SizedBox(height: 16),
            _DateRangeRow(project: project),
          ],
          if (project.research_areas?.isNotEmpty == true) ...[
            const SizedBox(height: 16),
            _ResearchAreaChips(
                areas: project.research_areas!
                    .map((a) => a.name ?? '')
                    .where((n) => n.isNotEmpty)
                    .toList()),
          ],
          if (project.description?.isNotEmpty == true) ...[
            const SizedBox(height: 20),
            Text(
              project.description!,
              style: const TextStyle(
                fontSize: 14,
                color: CustomColors.pine_shadow,
                height: 1.7,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ],
      ),
    );
  }

  bool get _hasDateInfo =>
      project.begin_date != null || project.end_date != null;
}

class _DateRangeRow extends StatelessWidget {
  final Projects project;

  const _DateRangeRow({required this.project});

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.calendar_today_outlined,
          size: 14,
          color: CustomColors.copper_spice,
        ),
        const SizedBox(width: 6),
        Text(
          'Início: ${_formatDate(project.begin_date)}',
          style: const TextStyle(
            fontSize: 13,
            color: CustomColors.pine_shadow,
          ),
        ),
        if (project.end_date != null) ...[
          const SizedBox(width: 16),
          const Icon(
            Icons.event_available_outlined,
            size: 14,
            color: CustomColors.copper_spice,
          ),
          const SizedBox(width: 6),
          Text(
            'Término: ${_formatDate(project.end_date)}',
            style: const TextStyle(
              fontSize: 13,
              color: CustomColors.pine_shadow,
            ),
          ),
        ],
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
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: areas.map((area) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: CustomColors.copper_spice.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: CustomColors.copper_spice.withOpacity(0.4),
            ),
          ),
          child: Text(
            area,
            style: const TextStyle(
              fontSize: 11,
              color: CustomColors.copper_spice,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}
