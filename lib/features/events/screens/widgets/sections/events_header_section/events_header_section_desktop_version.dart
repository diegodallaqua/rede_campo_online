import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class EventsHeaderSectionDesktopVersion extends StatelessWidget {
  const EventsHeaderSectionDesktopVersion({super.key});

  static const String _verse =
      'Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus, e te fortaleço, e te ajudo, e te sustento com a destra da minha justiça. Ela que envergonhados e confundidos serão todos os que se indignam contra ti; tornar-se-ão em nada, e perecerão os que contendem contigo.';

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
