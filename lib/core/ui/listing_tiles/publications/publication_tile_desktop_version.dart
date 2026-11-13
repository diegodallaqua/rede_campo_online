import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import '../../../../features/publications/models/publications.dart';
import '../../theme/custom_colors.dart';
import '../../theme/custom_text_styles.dart';
import '../../widgets/custom_row.dart';
import '../tile_card.dart';
import 'publication_tile_info.dart';

/// Card vertical de publicação: faixa com o tipo (artigo, livro...), título,
/// autores e, no rodapé, data e áreas de pesquisa. Quando tocável, exibe o
/// atalho "Ver publicação" e o card inteiro leva ao detalhe.
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

  /// Altura que as listagens reservam para cada card.
  static const double height = 290.0;

  @override
  Widget build(BuildContext context) {
    final authors = publication.authorsLabel();
    final areas = publication.areasLabel();
    final date = publication.publication_date;

    return TileCard(
      margin: margin,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TypeHeader(
            icon: publication.typeIcon,
            label: publication.typeLabel,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    publication.title ?? '-',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.cardTitleDesktop.copyWith(
                      color: CustomColors.pine_shadow,
                    ),
                  ),
                  if (authors != null) ...[
                    const SizedBox(height: 8),
                    CustomRow(
                      icon: Icons.person_outline_rounded,
                      text: authors,
                      textColor: CustomColors.midnight_slate,
                      fontSize: 13,
                      iconSize: 15,
                    ),
                  ],
                  const Spacer(),
                  if (date != null)
                    CustomRow(
                      icon: Icons.calendar_today_outlined,
                      text: date.formattedDate(),
                      textColor: CustomColors.midnight_slate,
                      fontSize: 13,
                      iconSize: 15,
                    ),
                  if (areas != null) ...[
                    const SizedBox(height: 6),
                    CustomRow(
                      icon: Icons.sell_outlined,
                      text: areas,
                      textColor: CustomColors.midnight_slate,
                      fontSize: 13,
                      iconSize: 15,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (onTap != null) const TileReadMore(label: 'Ver publicação'),
        ],
      ),
    );
  }
}

/// Faixa superior com o ícone e o nome do tipo da publicação. Ocupa o lugar
/// da imagem de capa dos demais cards, já que publicações não têm uma.
class _TypeHeader extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TypeHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: CustomColors.copper_spice.withOpacity(0.10),
        border: const Border(
          bottom: BorderSide(color: CustomColors.copper_spice, width: 2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: CustomColors.copper_spice,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: CustomColors.salt_flower),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.label.copyWith(
                color: CustomColors.copper_spice,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
