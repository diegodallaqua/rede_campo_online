import 'package:flutter/material.dart';
import '../../../../features/publications/models/publications.dart';
import '../../theme/custom_colors.dart';
import '../../theme/custom_text_styles.dart';
import '../../widgets/custom_row.dart';
import '../tile_card.dart';
import 'publication_tile_info.dart';

/// Card horizontal de publicação: à esquerda, o ícone do tipo e o ano; à
/// direita, tipo, título, autores e áreas de pesquisa.
class PublicationTileMobileVersion extends StatelessWidget {
  final Publications publication;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const PublicationTileMobileVersion({
    super.key,
    required this.publication,
    this.onTap,
    this.margin,
  });

  /// Altura fixa do card, usada também pelas listagens para calcular o
  /// espaço visível.
  static const double height = 136.0;
  static const double _sideWidth = 64.0;

  @override
  Widget build(BuildContext context) {
    final authors = publication.authorsLabel();
    final areas = publication.areasLabel();
    final year = publication.publication_date?.year;

    return TileCard(
      margin: margin,
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: _sideWidth,
              decoration: BoxDecoration(
                color: CustomColors.copper_spice.withOpacity(0.10),
                border: const Border(
                  right: BorderSide(color: CustomColors.copper_spice, width: 2),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    publication.typeIcon,
                    size: 26,
                    color: CustomColors.copper_spice,
                  ),
                  if (year != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      '$year',
                      style: CustomTextStyles.label.copyWith(
                        color: CustomColors.pine_shadow,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      publication.typeLabel.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.label.copyWith(
                        fontSize: 11,
                        color: CustomColors.copper_spice,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      publication.title ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.cardTitleMobile.copyWith(
                        fontSize: 15,
                        color: CustomColors.pine_shadow,
                      ),
                    ),
                    const Spacer(),
                    if (authors != null)
                      CustomRow(
                        icon: Icons.person_outline_rounded,
                        text: authors,
                        textColor: CustomColors.midnight_slate,
                        fontSize: 12,
                        iconSize: 14,
                      ),
                    if (areas != null) ...[
                      if (authors != null) const SizedBox(height: 4),
                      CustomRow(
                        icon: Icons.sell_outlined,
                        text: areas,
                        textColor: CustomColors.midnight_slate,
                        fontSize: 12,
                        iconSize: 14,
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
  }
}
