import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';

import '../../../../../../core/ui/listing_tiles/research_areas/research_area_tile.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/thesis.dart';
import '../../../../stores/thesis_details_store.dart';

class ThesisContentSectionMobileVersion extends StatelessWidget {
  final Thesis thesis;
  final ThesisDetailsStore store;

  const ThesisContentSectionMobileVersion({
    super.key,
    required this.thesis,
    required this.store,
  });

  String get _publicationLabel {
    final parts = <String>[];
    final org = thesis.organization?.name ?? '';
    final date = thesis.publication?.publication_date;
    if (org.isNotEmpty) parts.add(org);
    if (date != null) {
      final dateStr = date.formattedDate();
      if (dateStr.isNotEmpty) parts.add(dateStr);
    }
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final abstract = thesis.publication?.abstract ?? '';
    final areas = thesis.publication?.research_areas ?? [];
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
          Observer(
            builder: (_) {
              final showSummary = abstract.isNotEmpty &&
                  (store.translating || (store.summary?.isNotEmpty == true));
              if (!showSummary) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel(label: 'Summary'),
                  const SizedBox(height: 10),
                  _SummaryBody(
                    translating: store.translating,
                    summary: store.summary,
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
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
