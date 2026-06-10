import 'package:flutter/material.dart';
import '../../../../features/thesis/models/thesis.dart';
import '../../theme/custom_colors.dart';
import '../../widgets/custom_chip.dart';

class ThesisTileDesktopVersion extends StatelessWidget {
  final Thesis thesis;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const ThesisTileDesktopVersion({
    super.key,
    required this.thesis,
    this.onTap,
    this.margin,
  });

  static const double _borderRadius = 12.0;
  static const double _accentHeight = 3.0;

  @override
  Widget build(BuildContext context) {
    final pub = thesis.publication;
    final title = pub?.title ?? '—';
    final orgName = thesis.organization?.name ?? '';
    final year = pub?.publication_date?.year.toString() ?? '';
    final pages = thesis.number_of_pages;
    final pagesLabel = (pages != null && pages > 0) ? '$pages páginas' : '';
    final areas = pub?.research_areas
            ?.map((e) => e.name ?? '')
            .where((n) => n.isNotEmpty)
            .take(2)
            .toList() ??
        [];

    final content = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: CustomColors.vanilla_haze,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: _accentHeight,
            color: CustomColors.fresh_sprout,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.school_outlined,
                        size: 12,
                        color: CustomColors.fresh_sprout,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'DISSERTAÇÃO',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: CustomColors.fresh_sprout,
                          letterSpacing: 0.6,
                        ),
                      ),
                      if (year.isNotEmpty) ...[
                        const Spacer(),
                        CustomChip(
                          label: year,
                          color: CustomColors.pine_shadow,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.pine_shadow,
                      height: 1.35,
                    ),
                  ),
                  if (areas.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: areas
                          .map(
                            (area) => Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: CustomChip(
                                label: area,
                                color: CustomColors.fresh_sprout,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const Spacer(),
                  const Divider(
                    height: 1,
                    thickness: 0.8,
                    color: CustomColors.concrete_mist,
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance_outlined,
                        size: 12,
                        color: CustomColors.pine_shadow,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          orgName.isNotEmpty ? orgName : '—',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: CustomColors.pine_shadow,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (pagesLabel.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.auto_stories_outlined,
                          size: 11,
                          color: CustomColors.pine_shadow,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          pagesLabel,
                          style: TextStyle(
                            fontSize: 11,
                            color: CustomColors.pine_shadow.withOpacity(0.6),
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
    );

    return Container(
      margin: margin,
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(_borderRadius),
                onTap: onTap,
                child: content,
              ),
            ),
    );
  }
}
