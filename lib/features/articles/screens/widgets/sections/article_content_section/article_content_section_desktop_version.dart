import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rede_campo_online/core/utils/formatters.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/articles.dart';

class ArticleContentSectionDesktopVersion extends StatefulWidget {
  final Articles article;

  const ArticleContentSectionDesktopVersion({super.key, required this.article});

  @override
  State<ArticleContentSectionDesktopVersion> createState() =>
      _ArticleContentSectionDesktopVersionState();
}

class _ArticleContentSectionDesktopVersionState
    extends State<ArticleContentSectionDesktopVersion> {
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
    if (date != null) {
      final dateStr = date.formattedDate();
      if (dateStr.isNotEmpty) parts.add(dateStr);
    }
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final abstract = widget.article.publication?.abstract ?? '';
    final pubLabel = _publicationLabel;
    final showSummaryColumn =
        abstract.isNotEmpty && (_translating || (_summary?.isNotEmpty == true));

    if (abstract.isEmpty && pubLabel.isEmpty) return const SizedBox.shrink();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 56, 48, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (abstract.isNotEmpty) ...[
                Row(
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
                            const _SectionLabel(label: 'Summary'),
                            const SizedBox(height: 14),
                            _SummaryBody(
                              translating: _translating,
                              summary: _summary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 32),
              ],
              if (pubLabel.isNotEmpty)
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomColors.vanilla_haze.withOpacity(0.6),
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: 'Publicado em: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: CustomColors.vanilla_haze.withOpacity(0.8),
                        ),
                      ),
                      TextSpan(text: pubLabel),
                    ],
                  ),
                ),
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
