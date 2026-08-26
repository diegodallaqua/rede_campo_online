import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class AboutUsContentSectionMobileVersion extends StatelessWidget {
  const AboutUsContentSectionMobileVersion({super.key});

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
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 32, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _summaryText,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.7,
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 38),
          Text(
            'Missão',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
          ),
          SizedBox(height: 16),
          Text(
            _missionText,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Divider(color: CustomColors.fresh_sprout, thickness: 0.5),
          SizedBox(height: 18),
          Text(
            'Visão',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
          ),
          SizedBox(height: 16),
          Text(
            _visionText,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Divider(color: CustomColors.fresh_sprout, thickness: 0.5),
          SizedBox(height: 18),
          Text(
            'Valores',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
          ),
          SizedBox(height: 16),
          Text(
            _valuesText,
            style: TextStyle(
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
