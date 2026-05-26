import 'package:flutter/material.dart';
import 'package:rede_campo_online/features/technical_reports/stores/technical_reports_store.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../listing/technical_reports/publications_technical_reports_list_widget_desktop_version.dart';

class PublicationsTechnicalReportsSectionDesktopVersion extends StatefulWidget {
  final TechnicalReportsStore technicalReportsStore;

  const PublicationsTechnicalReportsSectionDesktopVersion({
    super.key,
    required this.technicalReportsStore,
  });

  @override
  State<PublicationsTechnicalReportsSectionDesktopVersion> createState() =>
      _PublicationsTechnicalReportsSectionDesktopVersionState();
}

class _PublicationsTechnicalReportsSectionDesktopVersionState
    extends State<PublicationsTechnicalReportsSectionDesktopVersion> {
  int _maxDiscoveredPage = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Relatórios Técnicos',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: CustomColors.fresh_sprout,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 64,
                      height: 3,
                      decoration: BoxDecoration(
                        color: CustomColors.fresh_sprout,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PublicationsTechnicalReportsListWidgetDesktopVersion(
                technicalReportsStore: widget.technicalReportsStore,
                maxDiscoveredPage: _maxDiscoveredPage,
                onPageDiscovered: (newMax) {
                  if (newMax != _maxDiscoveredPage) {
                    setState(() => _maxDiscoveredPage = newMax);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
