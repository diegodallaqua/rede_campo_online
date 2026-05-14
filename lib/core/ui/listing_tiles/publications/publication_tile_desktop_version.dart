import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import '../../../../features/publications/models/publications.dart';
import '../../theme/custom_colors.dart';

class PublicationTileDesktopVersion extends StatelessWidget {
  final Publications publication;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const PublicationTileDesktopVersion({
    super.key,
    required this.publication,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 12.0;

    final content = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: CustomColors.honey_cream,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 3,
            decoration: const BoxDecoration(
              color: CustomColors.copper_spice,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: CustomColors.copper_spice.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.article_outlined,
                            size: 12, color: CustomColors.copper_spice),
                        SizedBox(width: 4),
                        Text(
                          'PUBLICAÇÃO',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: CustomColors.copper_spice,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    publication.title ?? '—',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.pine_shadow,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  if (publication.publication_date != null) ...[
                    _MetaRow(
                      icon: Icons.calendar_today_outlined,
                      text: publication.publication_date!.formattedDate(),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (publication.research_areas != null &&
                      publication.research_areas!.isNotEmpty)
                    _MetaRow(
                      icon: Icons.sell_outlined,
                      text: () {
                        final areas = publication.research_areas!
                            .map((e) => e.name ?? '')
                            .where((n) => n.isNotEmpty)
                            .toList();
                        if (areas.length > 2) {
                          return '${areas.take(2).join(', ')} +${areas.length - 2}';
                        }
                        return areas.join(', ');
                      }(),
                    ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.copper_spice,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'SAIBA MAIS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Container(
      margin: margin,
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(borderRadius),
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: onTap,
                child: content,
              ),
            ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: CustomColors.copper_spice),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: CustomColors.pine_shadow,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
