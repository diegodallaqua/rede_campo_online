import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/technical_reports.dart';
import '../../listing/technical_report_authors_list_widget_desktop_version.dart';

class TechnicalReportAuthorsSectionDesktopVersion extends StatelessWidget {
  final TechnicalReports technicalReport;

  const TechnicalReportAuthorsSectionDesktopVersion({
    super.key,
    required this.technicalReport,
  });

  @override
  Widget build(BuildContext context) {
    final contributors = technicalReport.publication?.contributors ?? [];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 24, 48, 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Text(
                    'Autores do Relatório',
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
              TechnicalReportAuthorsListWidgetDesktopVersion(
                  contributors: contributors),
            ],
          ),
        ),
      ),
    );
  }
}
