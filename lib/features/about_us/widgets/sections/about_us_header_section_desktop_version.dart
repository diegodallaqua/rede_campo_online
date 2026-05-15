import 'package:flutter/material.dart';

import '../../../../core/ui/buttons/custom_buttom.dart';
import '../../../../core/ui/theme/custom_colors.dart';

class AboutUsHeaderSectionDesktopVersion extends StatelessWidget {
  const AboutUsHeaderSectionDesktopVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1440),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 72),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Conheça mais sobre a',
                            style: TextStyle(
                              fontSize: 16,
                              color: CustomColors.pine_shadow,
                            ),
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.w900,
                                color: CustomColors.midnight_slate,
                                height: 1.1,
                                fontFamily: 'RobotoSlab',
                              ),
                              children: [
                                TextSpan(text: 'Rede '),
                                TextSpan(
                                  text: 'Campo',
                                  style: TextStyle(
                                      color: CustomColors.copper_spice),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Pesquisa, inovação e extensão em desenvolvimento rural',
                            style: TextStyle(
                              fontSize: 17,
                              color: CustomColors.pine_shadow,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 40),
                          CustomButton(
                            width: 240,
                            color: CustomColors.honey_cream,
                            text: 'Veja Nossos Projetos',
                            textColor: CustomColors.midnight_slate,
                            borderRadius: 8,
                            fontWeight: FontWeight.w700,
                            function: () {
                              // TODO: navegar para a tela de projetos
                            },
                          ),
                        ],
                      ),
                    ),
                    const Expanded(flex: 4, child: SizedBox()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
