import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class EventsHeaderSectionMobileVersion extends StatelessWidget {
  const EventsHeaderSectionMobileVersion({super.key});

  static const String _verse =
      'Os eventos da Rede Campo são espaços de encontro entre ciência e território, palestras, workshops, dias de campo e atividades de extensão que aproximam pesquisadores, produtores, estudantes e comunidades rurais. São momentos de troca, aprendizado e construção coletiva, onde o conhecimento produzido dentro da universidade ganha vida no contato direto com as pessoas e os lugares que nos inspiram. Acompanhe os próximos eventos e venha fazer parte dessa conversa.';

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Acompanhe nossa programação de',
            style: TextStyle(
              fontSize: 14,
              color: CustomColors.pine_shadow,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Eventos',
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
