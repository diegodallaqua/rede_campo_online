import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/ui/buttons/custom_buttom.dart';
import '../../../../core/ui/theme/custom_colors.dart';

class HomeHeaderSectionMobileVersion extends StatelessWidget {
  const HomeHeaderSectionMobileVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.1,
            child: Transform.scale(
              scale: 2.25,
              child: Image.asset(
                'assets/images/logo_icon.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Conheça a Rede Campo!',
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColors.pine_shadow,
                  ),
                ),
                const SizedBox(height: 14),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: CustomColors.midnight_slate,
                      height: 1.35,
                      fontFamily: 'RobotoSlab',
                    ),
                    children: [
                      TextSpan(text: 'Levando '),
                      TextSpan(
                        text: 'inovação e\ntecnologia',
                        style: TextStyle(color: CustomColors.copper_spice),
                      ),
                      TextSpan(text: ' até o\nprodutor!'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
