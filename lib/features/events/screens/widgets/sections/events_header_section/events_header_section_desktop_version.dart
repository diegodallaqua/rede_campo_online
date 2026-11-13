import 'package:flutter/material.dart';
import '../../../../../../core/ui/sections/page_header_section.dart';

class EventsHeaderSectionDesktopVersion extends StatelessWidget {
  const EventsHeaderSectionDesktopVersion({super.key});

  static const String _verse =
      'Os eventos da Rede Campo são espaços de encontro entre ciência e território, palestras, workshops, dias de campo e atividades de extensão que aproximam pesquisadores, produtores, estudantes e comunidades rurais. São momentos de troca, aprendizado e construção coletiva, onde o conhecimento produzido dentro da universidade ganha vida no contato direto com as pessoas e os lugares que nos inspiram. Acompanhe os próximos eventos e venha fazer parte dessa conversa.';

  @override
  Widget build(BuildContext context) {
    return const PageHeaderSectionDesktopVersion(
      preTitle: 'Acompanhe nossa programação de',
      title: TextSpan(text: 'Eventos'),
      description: _verse,
    );
  }
}
