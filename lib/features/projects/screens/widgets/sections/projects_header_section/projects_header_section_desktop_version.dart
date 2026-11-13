import 'package:flutter/material.dart';
import '../../../../../../core/ui/sections/page_header_section.dart';

class ProjectsHeaderSectionDesktopVersion extends StatelessWidget {
  const ProjectsHeaderSectionDesktopVersion({super.key});

  static const String _verse =
      'Os projetos da Rede Campo reúnem iniciativas de pesquisa e extensão desenvolvidas em parceria com comunidades, produtores e organizações do meio rural. Cada projeto nasce de uma demanda real do território e é conduzido com rigor científico e compromisso prático, resultando em tecnologias, metodologias e soluções aplicadas ao desenvolvimento rural sustentável. Aqui você encontra o que estamos construindo, e o impacto que isso gera no campo.';

  @override
  Widget build(BuildContext context) {
    return const PageHeaderSectionDesktopVersion(
      preTitle: 'Saiba mais sobre os nossos',
      title: TextSpan(text: 'Projetos'),
      description: _verse,
    );
  }
}
