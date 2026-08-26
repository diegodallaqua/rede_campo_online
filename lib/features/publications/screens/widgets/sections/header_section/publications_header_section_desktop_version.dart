import 'package:flutter/material.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';

class PublicationsHeaderSectionDesktopVersion extends StatelessWidget {
  const PublicationsHeaderSectionDesktopVersion({super.key});

  static const String _verse =
      'As publicações da Rede Campo reúnem artigos científicos, livros e demais produções acadêmicas geradas pelo grupo ao longo de suas pesquisas. Fiel aos princípios da ciência aberta, disponibilizamos nossos trabalhos de forma acessível, para que pesquisadores, extensionistas e qualquer pessoa interessada possa acessar, aprender e construir sobre o que produzimos.';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 72),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Conheça as nossas',
                        style: TextStyle(
                          fontSize: 16,
                          color: CustomColors.pine_shadow,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Publicações',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w900,
                          color: CustomColors.copper_spice,
                          fontFamily: 'RobotoSlab',
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        _verse,
                        style: TextStyle(
                          fontSize: 15,
                          color: CustomColors.pine_shadow,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 4, child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
