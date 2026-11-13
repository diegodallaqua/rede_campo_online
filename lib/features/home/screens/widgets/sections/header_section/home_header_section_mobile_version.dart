import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/router.dart';
import '../../../../../../core/ui/buttons/custom_button.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/theme/custom_text_styles.dart';
import '../../../../../../core/ui/widgets/brand_emblem.dart';

class HomeHeaderSectionMobileVersion extends StatelessWidget {
  const HomeHeaderSectionMobileVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Opacity(opacity: 0.07, child: BrandEmblem(size: 340)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'CONHEÇA A REDE CAMPO',
                textAlign: TextAlign.center,
                style: CustomTextStyles.label.copyWith(
                  fontSize: 13,
                  letterSpacing: 1.5,
                  color: CustomColors.pine_shadow,
                ),
              ),
              const SizedBox(height: 14),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: CustomTextStyles.heroTitleMobile.copyWith(
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
              const SizedBox(height: 16),
              Text(
                'Pesquisa, inovação e extensão em desenvolvimento rural',
                style: CustomTextStyles.leadMobile.copyWith(
                  color: CustomColors.pine_shadow,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              CustomButton(
                width: double.infinity,
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
              const SizedBox(height: 12),
              CustomButton(
                width: double.infinity,
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
        ),
      ],
    );
  }
}
