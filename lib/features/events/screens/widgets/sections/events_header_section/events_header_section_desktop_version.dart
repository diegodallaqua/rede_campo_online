import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class EventsHeaderSectionDesktopVersion extends StatelessWidget {
  const EventsHeaderSectionDesktopVersion({super.key});

  static const String _verse =
      'Os eventos da Rede Campo são espaços de encontro entre ciência e território, palestras, workshops, dias de campo e atividades de extensão que aproximam pesquisadores, produtores, estudantes e comunidades rurais. São momentos de troca, aprendizado e construção coletiva, onde o conhecimento produzido dentro da universidade ganha vida no contato direto com as pessoas e os lugares que nos inspiram. Acompanhe os próximos eventos e venha fazer parte dessa conversa.';
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
                        'Acompanhe nossa programação de',
                        style: TextStyle(
                          fontSize: 16,
                          color: CustomColors.pine_shadow,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Eventos',
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
