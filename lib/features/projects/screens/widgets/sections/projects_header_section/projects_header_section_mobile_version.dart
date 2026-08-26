import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class ProjectsHeaderSectionMobileVersion extends StatelessWidget {
  const ProjectsHeaderSectionMobileVersion({super.key});

  static const String _verse =
      'Os projetos da Rede Campo reúnem iniciativas de pesquisa e extensão desenvolvidas em parceria com comunidades, produtores e organizações do meio rural. Cada projeto nasce de uma demanda real do território e é conduzido com rigor científico e compromisso prático, resultando em tecnologias, metodologias e soluções aplicadas ao desenvolvimento rural sustentável. Aqui você encontra o que estamos construindo, e o impacto que isso gera no campo.';

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Saiba mais sobre os nossos',
            style: TextStyle(
              fontSize: 14,
              color: CustomColors.pine_shadow,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Projetos',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: CustomColors.copper_spice,
              fontFamily: 'RobotoSlab',
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Text(
            _verse,
            style: TextStyle(
              fontSize: 14,
              color: CustomColors.pine_shadow,
              height: 1.7,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
