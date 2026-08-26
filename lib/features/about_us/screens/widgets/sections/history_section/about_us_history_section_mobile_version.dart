import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

import '../../listing/metrics/metric_highlights_widget.dart';

class AboutUsHistorySectionMobileVersion extends StatelessWidget {
  const AboutUsHistorySectionMobileVersion({super.key});

  static const String _historyText =
      'A Rede Campo surgiu em 2021 como um grupo de pesquisa vinculado à UTFPR Campus Santa Helena, reunindo pesquisadores e extensionistas com um objetivo em comum: aproximar a universidade do território rural por meio da ciência e da tecnologia. Desde o início, o grupo atuou na interface entre produção acadêmica e práticas aplicadas, desenvolvendo projetos voltados ao desenvolvimento rural sustentável e estabelecendo vínculos com comunidades, produtores e organizações da região. Com o crescimento das atividades, ficou evidente a necessidade de um espaço digital próprio que centralizasse as produções, organizasse a memória institucional do grupo e ampliasse o diálogo com públicos além da academia - superando os limites dos canais informais, como WhatsApp e Instagram, que eram utilizados até então. A criação desta plataforma representa, portanto, um passo importante na consolidação da Rede Campo como referência em extensão tecnológica rural, tornando seu trabalho mais visível, acessível e duradouro.';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 24,
                color: CustomColors.fresh_sprout,
                height: 1.2,
              ),
              children: [
                TextSpan(text: 'História da\n'),
                TextSpan(
                  text: 'Rede Campo',
                  style: TextStyle(
                      color: CustomColors.copper_spice,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            _historyText,
            style: TextStyle(
              fontSize: 14,
              color: CustomColors.pine_shadow,
              height: 1.7,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 32),
          const Text(
            'Destaques em Números',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: CustomColors.copper_spice,
            ),
          ),
          const SizedBox(height: 16),
          const MetricHighlightsWidget(),
        ],
      ),
    );
  }
}
