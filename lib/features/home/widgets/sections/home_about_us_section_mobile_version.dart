import 'package:flutter/material.dart';

import '../../../../core/ui/buttons/custom_buttom.dart';
import '../../../../core/ui/theme/custom_colors.dart';

class HomeAboutUsSectionMobileVersion extends StatelessWidget {
  const HomeAboutUsSectionMobileVersion({super.key});

  static const String _aboutText =
      'Eu te amarei do coração, ó Senhor, fortaleza minha. O Senhor é o meu rochedo, e o meu lugar forte, e o meu libertador; o meu Deus, a minha fortaleza, em quem confio; o meu escudo, a força da minha salvação, e o meu alto refúgio. Invocarei o nome do Senhor, que é digno de louvor, e ficarei livre dos meus inimigos. Cordas de morte me cercaram, e torrentes de impiedade me assombraram. Cordas do inferno me cingiram, laços de morte me surpreenderam. Na angústia invoquei o Senhor, e clamei ao meu Deus; desde o seu templo ouviu a minha voz, e aos seus ouvidos chegou o meu clamor perante a sua face.';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Sobre nós',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            _aboutText,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.7,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 28),
          CustomButton(
            width: 160,
            color: CustomColors.concrete_mist,
            text: 'Saiba mais',
            textColor: CustomColors.midnight_slate,
            borderRadius: 12,
            fontWeight: FontWeight.w700,
            function: () {
              // TODO: navegar para a tela sobre nós
            },
          ),
        ],
      ),
    );
  }
}
