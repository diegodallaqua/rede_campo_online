import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../models/research_areas.dart';
import '../../stores/translation_store.dart';
import '../listing_tiles/research_areas/research_area_tile.dart';
import '../theme/custom_colors.dart';

/// Seção de resumo (abstract) das telas de detalhe de publicações, com a
/// tradução para o inglês exibida ao lado - variante desktop.
class AbstractSectionDesktopVersion extends StatelessWidget {
  final String abstractText;
  final TranslationStore store;

  const AbstractSectionDesktopVersion({
    super.key,
    required this.abstractText,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    if (abstractText.isEmpty) return const SizedBox.shrink();

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
                  final showSummaryColumn = abstractText.isNotEmpty &&
                      (store.translating ||
                          (store.summary?.isNotEmpty == true));
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _SectionLabel(
                              label: 'Resumo',
                              color: CustomColors.vanilla_haze,
                              fontSize: 18,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              abstractText,
                              style: TextStyle(
                                fontSize: 15,
                                color:
                                    CustomColors.vanilla_haze.withOpacity(0.85),
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
                              const _SectionLabel(
                                label: 'Summary',
                                color: CustomColors.vanilla_haze,
                                fontSize: 18,
                              ),
                              const SizedBox(height: 14),
                              _SummaryBody(
                                translating: store.translating,
                                summary: store.summary,
                                textStyle: TextStyle(
                                  fontSize: 15,
                                  color: CustomColors.vanilla_haze
                                      .withOpacity(0.85),
                                  height: 1.8,
                                ),
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

/// Variante mobile da seção de resumo, com tradução, data de publicação e
/// áreas de pesquisa empilhadas verticalmente.
class AbstractSectionMobileVersion extends StatelessWidget {
  final String abstractText;
  final TranslationStore store;

  /// Texto exibido após "Publicado em:", montado pelo chamador a partir dos
  /// metadados específicos da publicação (periódico/volume, organização etc.).
  final String publishedLabel;
  final List<ResearchAreas> researchAreas;

  const AbstractSectionMobileVersion({
    super.key,
    required this.abstractText,
    required this.store,
    required this.publishedLabel,
    this.researchAreas = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.vanilla_haze,
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (abstractText.isNotEmpty) ...[
            const _SectionLabel(
              label: 'Resumo',
              color: CustomColors.pine_shadow,
              fontSize: 16,
            ),
            const SizedBox(height: 10),
            Text(
              abstractText,
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
              final showSummary = abstractText.isNotEmpty &&
                  (store.translating || (store.summary?.isNotEmpty == true));
              if (!showSummary) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel(
                    label: 'Summary',
                    color: CustomColors.pine_shadow,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 10),
                  _SummaryBody(
                    translating: store.translating,
                    summary: store.summary,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: CustomColors.pine_shadow,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
          const Divider(
              height: 1, thickness: 0.8, color: CustomColors.concrete_mist),
          const SizedBox(height: 16),
          if (publishedLabel.isNotEmpty) ...[
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
                  TextSpan(text: publishedLabel),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (researchAreas.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: researchAreas
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
  final Color color;
  final double fontSize;

  const _SectionLabel({
    required this.label,
    required this.color,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}

class _SummaryBody extends StatelessWidget {
  final bool translating;
  final String? summary;
  final TextStyle textStyle;

  const _SummaryBody({
    required this.translating,
    required this.summary,
    required this.textStyle,
  });

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
      style: textStyle,
      textAlign: TextAlign.justify,
    );
  }
}
