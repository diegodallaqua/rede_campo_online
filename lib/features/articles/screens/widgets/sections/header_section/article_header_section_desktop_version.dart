import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/ui/listing_tiles/research_areas/research_area_tile.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/custom_row.dart';
import '../../../../models/articles.dart';

class ArticleHeaderSectionDesktopVersion extends StatelessWidget {
  final Articles article;

  const ArticleHeaderSectionDesktopVersion({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final title = article.publication?.title ?? '—';
    final doi = article.publication?.doi ?? '';
    final areas = article.publication?.research_areas ?? [];

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
                        'ARTIGO',
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
                  child: _ArticleMetadataCard(article: article),
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

class _ArticleMetadataCard extends StatelessWidget {
  final Articles article;

  const _ArticleMetadataCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final date = article.publication?.publication_date;
    final dateStr = date != null
        ? '${date.day.toString().padLeft(2, '0')}/'
            '${date.month.toString().padLeft(2, '0')}/'
            '${date.year}'
        : null;

    final rows = <CustomRow>[
      if (article.journal_name?.isNotEmpty == true)
        CustomRow(
          icon: Icons.menu_book_outlined,
          text: 'Periódico: ${article.journal_name!}',
        ),
      if (article.volume?.isNotEmpty == true)
        CustomRow(
          icon: Icons.layers_outlined,
          text: 'Volume: ${article.volume!}',
        ),
      if (article.issue?.isNotEmpty == true)
        CustomRow(
          icon: Icons.numbers_outlined,
          text: 'Edição: ${article.issue!}',
        ),
      if (article.pages?.isNotEmpty == true)
        CustomRow(
          icon: Icons.import_contacts_outlined,
          text: 'Páginas: ${article.pages!}',
        ),
      if (article.publisher?.isNotEmpty == true)
        CustomRow(
          icon: Icons.business_outlined,
          text: 'Editora: ${article.publisher!}',
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
