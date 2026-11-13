import 'package:flutter/material.dart';
import '../../../../../../core/ui/sections/page_header_section.dart';

class NewsHeaderSectionDesktopVersion extends StatelessWidget {
  const NewsHeaderSectionDesktopVersion({super.key});

  static const String _verse =
      'Aqui você encontra os acontecimentos mais recentes da Rede Campo: novos projetos, parcerias institucionais, participações em eventos científicos, conquistas do grupo e tudo que marca nossa trajetória. Acreditamos que compartilhar o dia a dia do nosso trabalho é também uma forma de aproximar a universidade da sociedade, mostrando na prática, como a pesquisa e a extensão rural fazem diferença. Acompanhe e fique por dentro do que está acontecendo.';

  @override
  Widget build(BuildContext context) {
    return const PageHeaderSectionDesktopVersion(
      preTitle: 'Fique por dentro das últimas',
      title: TextSpan(text: 'Notícias'),
      description: _verse,
    );
  }
}
