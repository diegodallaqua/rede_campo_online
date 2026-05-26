import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class NewsHeaderSectionMobileVersion extends StatelessWidget {
  const NewsHeaderSectionMobileVersion({super.key});

  static const String _verse =
      'Não temas, porque eu estou contigo; não te assombres, porque eu sou o teu Deus; eu te fortaleço, e te ajudo, e te sustento com a destra da minha justiça.';

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Fique por dentro das últimas',
            style: TextStyle(
              fontSize: 14,
              color: CustomColors.pine_shadow,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Notícias',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: CustomColors.copper_spice,
              fontFamily: 'RobotoSlab',
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Text(
            _verse,
            style: TextStyle(
              fontSize: 14,
              color: CustomColors.pine_shadow,
              height: 1.7,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
