import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class ProjectsHeaderSectionDesktopVersion extends StatelessWidget {
  const ProjectsHeaderSectionDesktopVersion({super.key});

  static const String _verse =
      'Os projetos da Rede Campo reúnem iniciativas de pesquisa e extensão desenvolvidas em parceria com comunidades, produtores e organizações do meio rural. Cada projeto nasce de uma demanda real do território e é conduzido com rigor científico e compromisso prático, resultando em tecnologias, metodologias e soluções aplicadas ao desenvolvimento rural sustentável. Aqui você encontra o que estamos construindo, e o impacto que isso gera no campo.';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 72),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saiba mais sobre os nossos',
                        style: TextStyle(
                          fontSize: 16,
                          color: CustomColors.pine_shadow,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Projetos',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w900,
                          color: CustomColors.copper_spice,
                          fontFamily: 'RobotoSlab',
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        _verse,
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.pine_shadow,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 4, child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
