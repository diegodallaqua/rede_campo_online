import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class ProjectsHeaderSectionMobileVersion extends StatelessWidget {
  const ProjectsHeaderSectionMobileVersion({super.key});

  static const String _verse =
      'Não sabes, não ouviste que o Senhor é o Deus eterno, criador dos fins da terra? Ele não se cansa nem se fatiga, e a sua sabedoria é insondável. Dá força ao cansado, e multiplica as forças ao que não tem nenhum vigor. Os jovens se cansarão e se fatigarão, os moços certamente cairão; mas os que esperam no Senhor renovarão as suas forças; subirão com asas como águias; correrão, e não se cansarão; caminharão, e não se fatigarão.';

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 32, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Saiba mais sobre os nossos',
            style: TextStyle(
              fontSize: 14,
              color: CustomColors.pine_shadow,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Projetos',
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
