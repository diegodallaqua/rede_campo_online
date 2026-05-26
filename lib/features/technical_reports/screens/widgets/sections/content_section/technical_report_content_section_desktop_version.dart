import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/technical_reports.dart';
import '../../../../stores/technical_report_details_store.dart';

class TechnicalReportContentSectionDesktopVersion extends StatelessWidget {
  final TechnicalReports technicalReport;
  final TechnicalReportDetailsStore store;

  const TechnicalReportContentSectionDesktopVersion({
    super.key,
    required this.technicalReport,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final abstract = technicalReport.publication?.abstract ?? '';

    if (abstract.isEmpty) return const SizedBox.shrink();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 56, 48, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Observer(
                builder: (_) {
                  final showSummaryColumn = abstract.isNotEmpty &&
                      (store.translating ||
                          (store.summary?.isNotEmpty == true));
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _SectionLabel(label: 'Resumo'),
                            const SizedBox(height: 14),
                            Text(
                              abstract,
                              style: TextStyle(
                                fontSize: 15,
                                color: CustomColors.vanilla_haze
                                    .withOpacity(0.85),
                                height: 1.8,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                      if (showSummaryColumn) ...[
                        const SizedBox(width: 48),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _SectionLabel(label: 'Summary'),
                              const SizedBox(height: 14),
                              _SummaryBody(
                                translating: store.translating,
                                summary: store.summary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: CustomColors.vanilla_haze,
      ),
    );
  }
}

class _SummaryBody extends StatelessWidget {
  final bool translating;
  final String? summary;

  const _SummaryBody({required this.translating, required this.summary});

  @override
  Widget build(BuildContext context) {
    if (translating) {
      return const SizedBox(
        height: 20,
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: CustomColors.copper_spice,
            ),
          ),
        ),
      );
    }

    if (summary == null || summary!.isEmpty) return const SizedBox.shrink();

    return Text(
      summary!,
      style: TextStyle(
        fontSize: 15,
        color: CustomColors.vanilla_haze.withOpacity(0.85),
        height: 1.8,
      ),
      textAlign: TextAlign.justify,
    );
  }
}
