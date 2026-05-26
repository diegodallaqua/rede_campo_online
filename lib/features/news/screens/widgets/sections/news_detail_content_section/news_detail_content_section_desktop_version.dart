import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../models/news.dart';

class NewsDetailContentSectionDesktopVersion extends StatelessWidget {
  final News news;

  const NewsDetailContentSectionDesktopVersion({
    super.key,
    required this.news,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    const months = [
      'Jan.',
      'Fev.',
      'Mar.',
      'Abr.',
      'Mai.',
      'Jun.',
      'Jul.',
      'Ago.',
      'Set.',
      'Out.',
      'Nov.',
      'Dez.',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final content = news.content ?? '';
    final date = _formatDate(news.publication_date);
    final description = news.description ?? '';

    if (content.isEmpty && description.isEmpty && date.isEmpty) {
      return const SizedBox.shrink();
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 56, 48, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (description.isNotEmpty) ...[
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.vanilla_haze,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 32),
                Container(
                  height: 1,
                  color: CustomColors.vanilla_haze.withOpacity(0.12),
                ),
                const SizedBox(height: 32),
              ],
              if (content.isNotEmpty)
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: CustomColors.concrete_mist,
                    height: 1.8,
                  ),
                  textAlign: TextAlign.justify,
                ),
              if (date.isNotEmpty) ...[
                const SizedBox(height: 32),
                Text(
                  'Publicado em $date',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: CustomColors.concrete_mist.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
