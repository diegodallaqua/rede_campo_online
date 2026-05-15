import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../core/ui/buttons/custom_buttom.dart';
import '../../../../core/ui/theme/custom_colors.dart';

class HomeAboutUsSectionDesktopVersion extends StatelessWidget {
  const HomeAboutUsSectionDesktopVersion({super.key});

  static const String _aboutText =
      'Eu te amarei do coração, ó Senhor, fortaleza minha. O Senhor é o meu rochedo, e o meu lugar forte, e o meu libertador; o meu Deus, a minha fortaleza, em quem confio; o meu escudo, a força da minha salvação, e o meu alto refúgio. Invocarei o nome do Senhor, que é digno de louvor, e ficarei livre dos meus inimigos. Cordas de morte me cercaram, e torrentes de impiedade me assombraram. Cordas do inferno me cingiram, laços de morte me surpreenderam. Na angústia invoquei o Senhor, e clamei ao meu Deus; desde o seu templo ouviu a minha voz, e aos seus ouvidos chegou o meu clamor perante a sua face.';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 56, 48, 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sobre nós',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: CustomColors.fresh_sprout,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 64,
                height: 3,
                decoration: BoxDecoration(
                  color: CustomColors.fresh_sprout,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                _aboutText,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.9,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 36),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  width: 180,
                  color: CustomColors.concrete_mist,
                  text: 'Saiba mais',
                  textColor: CustomColors.midnight_slate,
                  borderRadius: 12,
                  fontWeight: FontWeight.w700,
                  function: () => context.go(AppRoutes.aboutUs),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
