import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import 'package:rede_campo_online/core/utils/repositories/translation_repository.dart';

import '../../../../../../core/ui/listing_tiles/research_areas/research_area_tile.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/technical_reports.dart';

class TechnicalReportContentSectionMobileVersion extends StatefulWidget {
  final TechnicalReports technicalReport;

  const TechnicalReportContentSectionMobileVersion({
    super.key,
    required this.technicalReport,
  });

  @override
  State<TechnicalReportContentSectionMobileVersion> createState() =>
      _TechnicalReportContentSectionMobileVersionState();
}

class _TechnicalReportContentSectionMobileVersionState
    extends State<TechnicalReportContentSectionMobileVersion> {
  String? _summary;
  bool _translating = false;

  @override
  void initState() {
    super.initState();
    _fetchTranslation();
  }

  Future<void> _fetchTranslation() async {
    final text = widget.technicalReport.publication?.abstract ?? '';
    if (text.isEmpty) return;

    setState(() => _translating = true);

    try {
      final translated = await TranslationRepository.translateToEnglish(text);
      if (mounted) setState(() => _summary = translated);
    } finally {
      if (mounted) setState(() => _translating = false);
    }
  }

  String get _publicationLabel {
    final parts = <String>[];
    final org = widget.technicalReport.organization?.name ?? '';
    final date = widget.technicalReport.publication?.publication_date;
    if (org.isNotEmpty) parts.add(org);
    if (date != null) {
      final dateStr = date.formattedDate();
      if (dateStr.isNotEmpty) parts.add(dateStr);
    }
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final abstract = widget.technicalReport.publication?.abstract ?? '';
    final areas = widget.technicalReport.publication?.research_areas ?? [];
    final pubLabel = _publicationLabel;

    return Container(
      color: CustomColors.vanilla_haze,
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (abstract.isNotEmpty) ...[
            const _SectionLabel(label: 'Resumo'),
            const SizedBox(height: 10),
            Text(
              abstract,
              style: const TextStyle(
                fontSize: 14,
                color: CustomColors.pine_shadow,
                height: 1.7,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
          ],
          if (abstract.isNotEmpty &&
              (_translating || (_summary?.isNotEmpty == true))) ...[
            const _SectionLabel(label: 'Summary'),
            const SizedBox(height: 10),
            _SummaryBody(translating: _translating, summary: _summary),
            const SizedBox(height: 20),
          ],
          const Divider(
              height: 1, thickness: 0.8, color: CustomColors.concrete_mist),
          const SizedBox(height: 16),
          if (pubLabel.isNotEmpty) ...[
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  color: CustomColors.pine_shadow,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: 'Publicado em: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: pubLabel),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (areas.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: areas
                  .map((area) => ResearchAreaTile(
                        researchArea: area,
                        green: true,
                      ))
                  .toList(),
            ),
        ],
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
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: CustomColors.pine_shadow,
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
      style: const TextStyle(
        fontSize: 14,
        color: CustomColors.pine_shadow,
        height: 1.7,
      ),
      textAlign: TextAlign.justify,
    );
  }
}
