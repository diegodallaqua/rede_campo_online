import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rede_campo_online/core/utils/formatters.dart';

import '../../../../../../core/ui/listing_tiles/research_areas/research_area_tile.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/articles.dart';

class ArticleContentSectionMobileVersion extends StatefulWidget {
  final Articles article;

  const ArticleContentSectionMobileVersion({super.key, required this.article});

  @override
  State<ArticleContentSectionMobileVersion> createState() =>
      _ArticleContentSectionMobileVersionState();
}

class _ArticleContentSectionMobileVersionState
    extends State<ArticleContentSectionMobileVersion> {
  String? _summary;
  bool _translating = false;

  @override
  void initState() {
    super.initState();
    _fetchTranslation();
  }

  Future<void> _fetchTranslation() async {
    final text = widget.article.publication?.abstract ?? '';
    if (text.isEmpty) return;

    setState(() => _translating = true);

    try {
      final uri = Uri.parse(
        'https://translate.googleapis.com/translate_a/single'
        '?client=gtx&sl=pt&tl=en&dt=t&q=${Uri.encodeComponent(text)}',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200 && mounted) {
        final List<dynamic> body = json.decode(response.body) as List<dynamic>;
        final List<dynamic> segments = body[0] as List<dynamic>;
        final translated = segments
            .map((s) => ((s as List<dynamic>)[0] as String?) ?? '')
            .join();
        setState(() => _summary = translated.isNotEmpty ? translated : null);
      }
    } catch (_) {
      // Silently omit the summary if the request fails
    } finally {
      if (mounted) setState(() => _translating = false);
    }
  }

  String get _publicationLabel {
    final parts = <String>[];
    final journal = widget.article.journal_name ?? '';
    final volume = widget.article.volume ?? '';
    final date = widget.article.publication?.publication_date;
    if (journal.isNotEmpty) parts.add(journal);
    if (volume.isNotEmpty) parts.add('v.$volume');
    final dateStr = date!.formattedDate();
    if (dateStr.isNotEmpty) parts.add(dateStr);
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final abstract = widget.article.publication?.abstract ?? '';
    final areas = widget.article.publication?.research_areas ?? [];
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
