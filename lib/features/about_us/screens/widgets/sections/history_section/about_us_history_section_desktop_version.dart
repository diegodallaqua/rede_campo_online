import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../listing/metrics/metric_highlights_widget.dart';

class AboutUsHistorySectionDesktopVersion extends StatelessWidget {
  const AboutUsHistorySectionDesktopVersion({super.key});

  static const String _historyText =
      'A Rede Campo surgiu em 2021 como um grupo de pesquisa vinculado à UTFPR Campus Santa Helena, reunindo pesquisadores e extensionistas com um objetivo em comum: aproximar a universidade do território rural por meio da ciência e da tecnologia. Desde o início, o grupo atuou na interface entre produção acadêmica e práticas aplicadas, desenvolvendo projetos voltados ao desenvolvimento rural sustentável e estabelecendo vínculos com comunidades, produtores e organizações da região. Com o crescimento das atividades, ficou evidente a necessidade de um espaço digital próprio que centralizasse as produções, organizasse a memória institucional do grupo e ampliasse o diálogo com públicos além da academia - superando os limites dos canais informais, como WhatsApp e Instagram, que eram utilizados até então. A criação desta plataforma representa, portanto, um passo importante na consolidação da Rede Campo como referência em extensão tecnológica rural, tornando seu trabalho mais visível, acessível e duradouro.';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 36,
                              color: CustomColors.fresh_sprout,
                              height: 1.2,
                            ),
                            children: [
                              TextSpan(text: 'História\nda '),
                              TextSpan(
                                text: 'Rede\nCampo',
                                style: TextStyle(
                                  color: CustomColors.copper_spice,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: CustomColors.copper_spice,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 64),
                  const Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          _historyText,
                          style: TextStyle(
                            fontSize: 15,
                            color: CustomColors.pine_shadow,
                            height: 1.8,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Row(
                children: [
                  const Text(
                    'Destaques em Números',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.copper_spice,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            CustomColors.copper_spice.withOpacity(0.4),
                            CustomColors.copper_spice.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const MetricHighlightsWidget(isDesktop: true),
            ],
          ),
        ),
      ),
    );
  }
}
