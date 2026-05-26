import 'package:flutter/material.dart';
import 'package:rede_campo_online/features/technical_reports/stores/technical_reports_store.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../listing/technical_reports/publications_technical_reports_list_widget_mobile_version.dart';

class PublicationsTechnicalReportsSectionMobileVersion extends StatefulWidget {
  final TechnicalReportsStore technicalReportsStore;

  const PublicationsTechnicalReportsSectionMobileVersion({
    super.key,
    required this.technicalReportsStore,
  });

  @override
  State<PublicationsTechnicalReportsSectionMobileVersion> createState() =>
      _PublicationsTechnicalReportsSectionMobileVersionState();
}

class _PublicationsTechnicalReportsSectionMobileVersionState
    extends State<PublicationsTechnicalReportsSectionMobileVersion> {
  int _maxDiscoveredPage = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Relatórios Técnicos',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 16),
          PublicationsTechnicalReportsListWidgetMobileVersion(
            technicalReportsStore: widget.technicalReportsStore,
            maxDiscoveredPage: _maxDiscoveredPage,
            onPageDiscovered: (newMax) {
              if (newMax > _maxDiscoveredPage) {
                setState(() => _maxDiscoveredPage = newMax);
              }
            },
          ),
        ],
      ),
    );
  }
}
