import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/ui/listing_tiles/research_areas/research_area_tile.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/custom_row.dart';
import '../../../../models/thesis.dart';

class ThesisHeaderSectionDesktopVersion extends StatelessWidget {
  final Thesis thesis;

  const ThesisHeaderSectionDesktopVersion({
    super.key,
    required this.thesis,
  });

  @override
  Widget build(BuildContext context) {
    final title = thesis.publication?.title ?? '-';
    final doi = thesis.publication?.doi ?? '';
    final areas = thesis.publication?.research_areas ?? [];

    return Container(
      color: CustomColors.vanilla_haze,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DISSERTAÇÃO / TESE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.copper_spice,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          color: CustomColors.midnight_slate,
                          fontFamily: 'RobotoSlab',
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: 56,
                        height: 4,
                        decoration: BoxDecoration(
                          color: CustomColors.copper_spice,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      if (doi.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _DoiLink(doi: doi),
                      ],
                      if (areas.isNotEmpty) ...[
                        const SizedBox(height: 20),
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
                    ],
                  ),
                ),
                const SizedBox(width: 64),
                Expanded(
                  flex: 3,
                  child: _ThesisMetadataCard(thesis: thesis),
                ),
              ],
            ),
          ),
        ),
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

class _ThesisMetadataCard extends StatelessWidget {
  final Thesis thesis;

  const _ThesisMetadataCard({required this.thesis});

  @override
  Widget build(BuildContext context) {
    final date = thesis.publication?.publication_date;
    final dateStr = date != null
        ? '${date.day.toString().padLeft(2, '0')}/'
            '${date.month.toString().padLeft(2, '0')}/'
            '${date.year}'
        : null;
    final orgName = thesis.organization?.name;
    final pages = thesis.number_of_pages;

    final rows = <CustomRow>[
      if (orgName?.isNotEmpty == true)
        CustomRow(
          icon: Icons.business_outlined,
          text: 'Organização: $orgName',
        ),
      if (pages != null && pages > 0)
        CustomRow(
          icon: Icons.import_contacts_outlined,
          text: 'Páginas: $pages',
        ),
      if (dateStr != null)
        CustomRow(
          icon: Icons.calendar_today_outlined,
          text: 'Publicado em: $dateStr',
        ),
    ];

    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CustomColors.copper_spice.withOpacity(0.2),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'INFORMAÇÕES',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: CustomColors.copper_spice,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i < rows.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
