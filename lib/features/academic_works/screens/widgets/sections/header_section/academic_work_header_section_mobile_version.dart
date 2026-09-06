import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/utils/formatters.dart';
import '../../../../models/academic_work.dart';

class AcademicWorkHeaderSectionMobileVersion extends StatelessWidget {
  final AcademicWork academicWork;

  const AcademicWorkHeaderSectionMobileVersion({
    super.key,
    required this.academicWork,
  });

  @override
  Widget build(BuildContext context) {
    final title = academicWork.publication?.title ?? '-';
    final doi = academicWork.publication?.doi ?? '';
    final typeLabel = academicWork.academic_work_type?.label ?? '';
    final pages = academicWork.number_of_pages;
    final defenseDate = academicWork.defense_date;

    final details = [
      if (defenseDate != null) 'Defendido em ${defenseDate.formattedDate()}',
      if (pages != null && pages > 0) '$pages páginas',
    ].join('  ·  ');

    return Container(
      color: CustomColors.vanilla_haze,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (typeLabel.isNotEmpty) ...[
            Text(
              typeLabel.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: CustomColors.pine_shadow,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: CustomColors.copper_spice,
              fontFamily: 'RobotoSlab',
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          if (details.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              details,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: CustomColors.pine_shadow,
              ),
            ),
          ],
          if (doi.isNotEmpty) ...[
            const SizedBox(height: 12),
            _DoiLink(doi: doi),
          ],
        ],
      ),
    );
  }
}

class _DoiLink extends StatelessWidget {
  final String doi;

  const _DoiLink({required this.doi});

  String get _resolvedUrl =>
      doi.startsWith('http') ? doi : 'https://doi.org/$doi';

  Future<void> _open() async {
    final uri = Uri.tryParse(_resolvedUrl);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _open,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DOI: ',
            style: TextStyle(
              fontSize: 13,
              color: CustomColors.pine_shadow,
            ),
          ),
          Flexible(
            child: Text(
              doi,
              style: const TextStyle(
                fontSize: 13,
                color: CustomColors.fresh_sprout,
                decoration: TextDecoration.underline,
                decorationColor: CustomColors.fresh_sprout,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
