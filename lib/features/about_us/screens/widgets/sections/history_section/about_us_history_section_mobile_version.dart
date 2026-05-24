import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

import '../../listing/metric_highlights_widget.dart';

class AboutUsHistorySectionMobileVersion extends StatelessWidget {
  const AboutUsHistorySectionMobileVersion({super.key});

  static const String _historyText =
      'Não sabes, não ouviste que o eterno Deus, o Senhor, o Criador dos fins da terra, nem se cansa nem se fatiga? Não há esquadrinhação do seu entendimento. Dá força ao cansado, e multiplica as forças ao que não tem nenhum vigor. Os jovens se cansarão e se fatigarão, e os moços certamente cairão; mas os que esperam no Senhor renovarão as forças, subirão com asas como águias; correrão, e não se cansarão; andarão, e não se fatigarão.';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 24,
                color: CustomColors.fresh_sprout,
                height: 1.2,
              ),
              children: [
                TextSpan(text: 'História da\n'),
                TextSpan(
                  text: 'Rede Campo',
                  style: TextStyle(
                      color: CustomColors.copper_spice,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            _historyText,
            style: TextStyle(
              fontSize: 14,
              color: CustomColors.pine_shadow,
              height: 1.7,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 32),
          const Text(
            'Destaques em Números',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: CustomColors.copper_spice,
            ),
          ),
          const SizedBox(height: 16),
          const MetricHighlightsWidget(),
        ],
      ),
    );
  }
}
