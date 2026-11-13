import 'package:flutter/material.dart';
import '../../../../../../core/ui/sections/page_header_section.dart';

class PublicationsHeaderSectionDesktopVersion extends StatelessWidget {
  const PublicationsHeaderSectionDesktopVersion({super.key});

  static const String _verse =
      'As publicações da Rede Campo reúnem artigos científicos, livros e demais produções acadêmicas geradas pelo grupo ao longo de suas pesquisas. Fiel aos princípios da ciência aberta, disponibilizamos nossos trabalhos de forma acessível, para que pesquisadores, extensionistas e qualquer pessoa interessada possa acessar, aprender e construir sobre o que produzimos.';

  @override
  Widget build(BuildContext context) {
    return const PageHeaderSectionDesktopVersion(
      preTitle: 'Conheça as nossas',
      title: TextSpan(text: 'Publicações'),
      description: _verse,
    );
  }
}
