import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';

class AboutUsContentSectionDesktopVersion extends StatelessWidget {
  const AboutUsContentSectionDesktopVersion({super.key});

  static const String _summaryText =
      'A Rede Campo é um grupo de pesquisa e extensão da UTFPR Campus Santa Helena, fundado em 2021, com foco em tecnologias aplicadas ao desenvolvimento rural sustentável. Reunimos pesquisadores e extensionistas comprometidos em aproximar universidade e território, traduzindo produção científica em soluções reais para o campo. Atuamos de forma colaborativa e com princípios de ciência aberta, organizando nossas produções, projetos e ações em um espaço digital acessível a agricultores, comunidades, parceiros e ao público em geral.';

  static const String _missionText =
      'Desenvolver, compartilhar e transferir tecnologias aplicadas ao desenvolvimento rural sustentável, articulando pesquisa científica e extensão universitária para fortalecer comunidades, produtores e organizações do campo.';

  static const String _visionText =
      'Ser referência regional na integração entre ciência aberta e extensão tecnológica rural, reconhecida pela qualidade das produções, pela transparência das práticas e pelo impacto concreto nos territórios onde atuamos.';

  static const String _valuesText =
      'Nosso trabalho é guiado pela ciência aberta, pela valorização do território rural, pela inovação aplicada e pela colaboração em rede, sempre com foco no impacto social concreto nas comunidades que atendemos.';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 48, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _summaryText,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  height: 1.8,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 56),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: _MvvCard(title: 'Missão', body: _missionText)),
                  _VerticalDivider(),
                  Expanded(child: _MvvCard(title: 'Visão', body: _visionText)),
                  _VerticalDivider(),
                  Expanded(
                      child: _MvvCard(title: 'Valores', body: _valuesText)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MvvCard extends StatelessWidget {
  final String title;
  final String body;

  const _MvvCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            body,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 80,
      color: CustomColors.fresh_sprout.withOpacity(0.35),
    );
  }
}
