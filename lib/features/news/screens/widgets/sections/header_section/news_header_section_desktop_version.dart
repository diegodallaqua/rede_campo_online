import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class NewsHeaderSectionDesktopVersion extends StatelessWidget {
  const NewsHeaderSectionDesktopVersion({super.key});

  static const String _verse =
      'Aqui você encontra os acontecimentos mais recentes da Rede Campo: novos projetos, parcerias institucionais, participações em eventos científicos, conquistas do grupo e tudo que marca nossa trajetória. Acreditamos que compartilhar o dia a dia do nosso trabalho é também uma forma de aproximar a universidade da sociedade, mostrando na prática, como a pesquisa e a extensão rural fazem diferença. Acompanhe e fique por dentro do que está acontecendo.';

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
                        'Fique por dentro das últimas',
                        style: TextStyle(
                          fontSize: 16,
                          color: CustomColors.pine_shadow,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Notícias',
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
