import 'package:flutter/material.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';

class PublicationsHeaderSectionMobileVersion extends StatelessWidget {
  const PublicationsHeaderSectionMobileVersion({super.key});

  static const String _verse =
      'As publicações da Rede Campo reúnem artigos científicos, livros e demais produções acadêmicas geradas pelo grupo ao longo de suas pesquisas. Fiel aos princípios da ciência aberta, disponibilizamos nossos trabalhos de forma acessível, para que pesquisadores, extensionistas e qualquer pessoa interessada possa acessar, aprender e construir sobre o que produzimos.';

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Conheça as nossas',
            style: TextStyle(
              fontSize: 14,
              color: CustomColors.pine_shadow,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Publicações',
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
