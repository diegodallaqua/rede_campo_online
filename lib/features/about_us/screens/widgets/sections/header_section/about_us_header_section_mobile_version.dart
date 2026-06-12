import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/core/ui/buttons/custom_button.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

import '../../../../../../app/router.dart';

class AboutUsHeaderSectionMobileVersion extends StatelessWidget {
  const AboutUsHeaderSectionMobileVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Conheça mais sobre a',
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColors.pine_shadow,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: CustomColors.midnight_slate,
                      height: 1.2,
                      fontFamily: 'RobotoSlab',
                    ),
                    children: [
                      TextSpan(text: 'Rede '),
                      TextSpan(
                        text: 'Campo',
                        style: TextStyle(color: CustomColors.copper_spice),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Pesquisa, inovação e extensão em\ndesenvolvimento rural',
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColors.pine_shadow,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                CustomButton(
                  width: MediaQuery.sizeOf(context).width * 0.55,
                  color: CustomColors.honey_cream,
                  text: 'Veja Nossos Projetos',
                  textColor: CustomColors.midnight_slate,
                  borderRadius: 8,
                  fontWeight: FontWeight.w700,
                  function: () => context.go(AppRoutes.projects),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
