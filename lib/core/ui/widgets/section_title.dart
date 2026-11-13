import 'package:flutter/material.dart';

import '../theme/custom_text_styles.dart';

/// Título de seção com linha guia: a barrinha de destaque continua como uma
/// linha fina até a borda da grade, ligando o título à listagem abaixo.
///
/// [trailing] ocupa o restante da linha do título, alinhado à direita
/// (por exemplo, [SectionTitleAction] ou uma barra de busca).
class SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  final TextStyle style;
  final Widget? trailing;
  final bool centered;

  const SectionTitle({
    super.key,
    required this.title,
    required this.color,
    this.style = CustomTextStyles.sectionTitleDesktop,
    this.trailing,
    this.centered = false,
  });

  /// Variante com o tamanho de título usado nas versões mobile.
  const SectionTitle.mobile({
    super.key,
    required this.title,
    required this.color,
    this.trailing,
    this.centered = false,
  }) : style = CustomTextStyles.sectionTitleMobile;

  @override
  Widget build(BuildContext context) {
    final titleText = Text(
      title,
      style: style.copyWith(color: color),
      textAlign: centered ? TextAlign.center : TextAlign.start,
    );

    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
      children: [
        if (trailing == null)
          titleText
        else
          Row(
            children: [
              titleText,
              const SizedBox(width: 32),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: trailing,
                ),
              ),
            ],
          ),
        SizedBox(height: style.fontSize! >= 32 ? 12 : 10),
        _GuideLine(color: color, centered: centered),
      ],
    );
  }
}

class _GuideLine extends StatelessWidget {
  final Color color;
  final bool centered;

  const _GuideLine({required this.color, required this.centered});

  @override
  Widget build(BuildContext context) {
    final hairline = Expanded(
      child: Container(height: 1, color: color.withOpacity(0.3)),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (centered) hairline,
        Container(
          width: 64,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        hairline,
      ],
    );
  }
}

/// Link "Ver todas →" exibido à direita de um [SectionTitle].
class SectionTitleAction extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const SectionTitleAction({
    super.key,
    this.label = 'Ver todas',
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: color,
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_forward_rounded, size: 18),
        ],
      ),
    );
  }
}
