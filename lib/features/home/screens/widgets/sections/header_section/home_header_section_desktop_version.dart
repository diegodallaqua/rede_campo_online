import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../app/router.dart';
import '../../../../../../core/ui/buttons/custom_button.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/theme/custom_text_styles.dart';
import '../../../../../../core/ui/widgets/brand_emblem.dart';

class HomeHeaderSectionDesktopVersion extends StatelessWidget {
  const HomeHeaderSectionDesktopVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Opacity(opacity: 0.07, child: BrandEmblem(size: 640)),
            ),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 96),
              child: Column(
                children: [
                  Text(
                    'CONHEÇA A REDE CAMPO',
                    style: CustomTextStyles.label.copyWith(
                      fontSize: 15,
                      letterSpacing: 2,
                      color: CustomColors.pine_shadow,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 980),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: CustomTextStyles.heroTitleDesktop.copyWith(
                          color: CustomColors.midnight_slate,
                        ),
                        children: const [
                          TextSpan(text: 'Levando '),
                          TextSpan(
                            text: 'inovação e tecnologia',
                            style: TextStyle(color: CustomColors.copper_spice),
                          ),
                          TextSpan(text: ' até o produtor!'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Pesquisa, inovação e extensão em desenvolvimento rural',
                    style: CustomTextStyles.leadDesktop.copyWith(
                      color: CustomColors.pine_shadow,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                        width: 264,
                        height: 52,
                        elevation: 0,
                        color: CustomColors.copper_spice,
                        text: 'Veja Nossos Projetos',
                        textColor: Colors.white,
                        borderRadius: 10,
                        fontWeight: FontWeight.w700,
                        trailingIcon: Icons.arrow_forward_rounded,
                        function: () => context.go(AppRoutes.projects),
                      ),
                      const SizedBox(width: 16),
                      CustomButton(
                        width: 232,
                        height: 52,
                        elevation: 0,
                        color: Colors.transparent,
                        borderColor: CustomColors.pine_shadow,
                        text: 'Sobre a Rede Campo',
                        textColor: CustomColors.pine_shadow,
                        borderRadius: 10,
                        fontWeight: FontWeight.w700,
                        function: () => context.go(AppRoutes.aboutUs),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
