import 'package:flutter/material.dart';

import '../../utils/placeholders.dart';
import '../theme/custom_colors.dart';

/// Moldura comum dos cards de listagem (notícias, projetos e eventos):
/// fundo creme, cantos de 12px e, quando tocável, sobe 2px com sombra ao
/// passar o mouse. O card inteiro é a área de toque.
class TileCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const TileCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
  });

  static const double borderRadius = 12;

  @override
  State<TileCard> createState() => _TileCardState();
}

class _TileCardState extends State<TileCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final lifted = widget.onTap != null && _hovered;
    final radius = BorderRadius.circular(TileCard.borderRadius);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      margin: widget.margin,
      transform: Matrix4.translationValues(0, lifted ? -2 : 0, 0),
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color:
                CustomColors.midnight_slate.withOpacity(lifted ? 0.28 : 0.12),
            blurRadius: lifted ? 18 : 8,
            offset: Offset(0, lifted ? 8 : 2),
          ),
        ],
      ),
      child: Material(
        color: CustomColors.vanilla_haze,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          onHover: (value) => setState(() => _hovered = value),
          splashColor: CustomColors.copper_spice.withOpacity(0.08),
          highlightColor: CustomColors.copper_spice.withOpacity(0.04),
          hoverColor: Colors.transparent,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Imagem de capa do card, com [ImagePlaceholder] quando não há imagem ou o
/// carregamento falha.
class TileCover extends StatelessWidget {
  final String? imageUrl;
  final double height;

  const TileCover({super.key, required this.imageUrl, required this.height});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: url != null && url.isNotEmpty
          ? Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const ImagePlaceholder(),
            )
          : const ImagePlaceholder(),
    );
  }
}

/// Rodapé "Saiba mais →" dos cards. É só indicação visual: o toque é do card.
class TileReadMore extends StatelessWidget {
  final String label;
  final IconData icon;

  const TileReadMore({
    super.key,
    this.label = 'Saiba mais',
    this.icon = Icons.arrow_forward_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: CustomColors.soft_border)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: CustomColors.copper_spice,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Icon(icon, size: 16, color: CustomColors.copper_spice),
        ],
      ),
    );
  }
}
