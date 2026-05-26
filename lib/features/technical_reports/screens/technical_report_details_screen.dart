import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/ui/layout/app_scaffold.dart';
import '../../../core/ui/layout/footer.dart';
import '../../../core/ui/theme/custom_colors.dart';
import '../models/technical_reports.dart';
import 'widgets/sections/authors_section/technical_report_authors_section_desktop_version.dart';
import 'widgets/sections/authors_section/technical_report_authors_section_mobile_version.dart';
import 'widgets/sections/content_section/technical_report_content_section_desktop_version.dart';
import 'widgets/sections/content_section/technical_report_content_section_mobile_version.dart';
import 'widgets/sections/header_section/technical_report_header_section_desktop_version.dart';
import 'widgets/sections/header_section/technical_report_header_section_mobile_version.dart';

class TechnicalReportDetailsScreen extends StatelessWidget {
  final TechnicalReports technicalReport;

  const TechnicalReportDetailsScreen({super.key, required this.technicalReport});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TechnicalReportHeaderSectionMobileVersion(technicalReport: technicalReport),
              TechnicalReportContentSectionMobileVersion(technicalReport: technicalReport),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: TechnicalReportAuthorsSectionMobileVersion(technicalReport: technicalReport),
              ),
              const SizedBox(height: 16),
              const Footer(),
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TechnicalReportHeaderSectionDesktopVersion(technicalReport: technicalReport),
              ColoredBox(
                color: CustomColors.midnight_slate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TechnicalReportContentSectionDesktopVersion(technicalReport: technicalReport),
                    TechnicalReportAuthorsSectionDesktopVersion(technicalReport: technicalReport),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
