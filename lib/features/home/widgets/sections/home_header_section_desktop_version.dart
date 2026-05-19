import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../core/ui/buttons/custom_buttom.dart';
import '../../../../core/ui/theme/custom_colors.dart';

class HomeHeaderSectionDesktopVersion extends StatelessWidget {
  const HomeHeaderSectionDesktopVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.1,
            child: Transform.scale(
              scale: 2.5,
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
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Conheça a Rede Campo!',
                        style: TextStyle(
                          fontSize: 38,
                          color: CustomColors.pine_shadow,
                        ),
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 86,
                            fontWeight: FontWeight.w900,
                            color: CustomColors.midnight_slate,
                            height: 1.2,
                            fontFamily: 'RobotoSlab',
                          ),
                          children: [
                            TextSpan(text: 'Levando '),
                            TextSpan(
                              text: 'inovação e tecnologia',
                              style:
                                  TextStyle(color: CustomColors.copper_spice),
                            ),
                            TextSpan(text: ' até o produtor!'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Pesquisa, inovação e extensão em desenvolvimento rural',
                        style: TextStyle(
                          fontSize: 38,
                          color: CustomColors.pine_shadow,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        width: 260,
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
            ),
          ),
        ),
      ],
    );
  }
}
