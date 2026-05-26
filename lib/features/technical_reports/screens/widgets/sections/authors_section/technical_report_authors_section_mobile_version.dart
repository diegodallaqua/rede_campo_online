import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/technical_reports.dart';
import '../../listing/authors/technical_report_authors_list_widget_mobile_version.dart';

class TechnicalReportAuthorsSectionMobileVersion extends StatelessWidget {
  final TechnicalReports technicalReport;

  const TechnicalReportAuthorsSectionMobileVersion({
    super.key,
    required this.technicalReport,
  });

  @override
  Widget build(BuildContext context) {
    final contributors = technicalReport.publication?.contributors ?? [];

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Autores do Relatório',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TechnicalReportAuthorsListWidgetMobileVersion(
              contributors: contributors),
        ],
      ),
    );
  }
}
