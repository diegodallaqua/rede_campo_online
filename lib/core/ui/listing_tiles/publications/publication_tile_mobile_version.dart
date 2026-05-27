import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import '../../../../features/publications/models/publications.dart';
import '../../theme/custom_colors.dart';
import '../../widgets/custom_chip.dart';

class PublicationTileMobileVersion extends StatelessWidget {
  final Publications publication;
  final EdgeInsetsGeometry? margin;

  const PublicationTileMobileVersion({
    super.key,
    required this.publication,
    this.margin,
  });

  static const double _height = 145.0;
  static const double _accentWidth = 5.0;
  static const double _borderRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    final title = publication.title ?? '—';
    final abstract = publication.abstract?.trim();
    final date = publication.publication_date;
    final year = date != null ? date.year.toString() : '';

    final areas = (publication.research_areas ?? [])
        .map((e) => e.name ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    final areasLabel = areas.isEmpty
        ? ''
        : areas.length > 3
            ? '${areas.take(3).join(', ')}  +${areas.length - 3}'
            : areas.join(', ');

    final hasDoi =
        publication.doi != null && publication.doi!.trim().isNotEmpty;

    final card = SizedBox(
      height: _height,
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.honey_cream,
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: _accentWidth,
              color: CustomColors.copper_spice,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: CustomColors.pine_shadow,
                        height: 1.35,
                      ),
                    ),
                    if (abstract != null && abstract.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        abstract,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: CustomColors.pine_shadow.withOpacity(0.7),
                          height: 1.3,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Divider(
                      height: 1,
                      thickness: 0.8,
                      color: CustomColors.copper_spice.withOpacity(0.4),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(
                          Icons.sell_outlined,
                          size: 12,
                          color: CustomColors.pine_shadow,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            areasLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: CustomColors.pine_shadow,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (hasDoi) ...[
                          const SizedBox(width: 8),
                          const CustomChip(
                              label: 'DOI', color: CustomColors.copper_spice),
                        ],
                      ],
                    ),
                    if (year.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 11,
                            color: CustomColors.pine_shadow,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            date!.formattedDate(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: CustomColors.pine_shadow,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Container(margin: margin, child: card);
  }
}
