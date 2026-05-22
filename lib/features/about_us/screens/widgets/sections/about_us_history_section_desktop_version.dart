import 'package:flutter/material.dart';

import '../../../../../core/ui/theme/custom_colors.dart';
import '../listing/metric_highlights_widget.dart';

class AboutUsHistorySectionDesktopVersion extends StatelessWidget {
  const AboutUsHistorySectionDesktopVersion({super.key});

  static const String _historyText =
      'Não sabes, não ouviste que o eterno Deus, o Senhor, o Criador dos fins da terra, nem se cansa nem se fatiga? Não há esquadrinhação do seu entendimento. Dá força ao cansado, e multiplica as forças ao que não tem nenhum vigor. Os jovens se cansarão e se fatigarão, e os moços certamente cairão; mas os que esperam no Senhor renovarão as forças, subirão com asas como águias; correrão, e não se cansarão; andarão, e não se fatigarão.';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 36,
                              color: CustomColors.fresh_sprout,
                              height: 1.2,
                            ),
                            children: [
                              TextSpan(text: 'História\nda '),
                              TextSpan(
                                text: 'Rede\nCampo',
                                style: TextStyle(
                                  color: CustomColors.copper_spice,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: CustomColors.copper_spice,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 64),
                  const Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          _historyText,
                          style: TextStyle(
                            fontSize: 15,
                            color: CustomColors.pine_shadow,
                            height: 1.8,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Row(
                children: [
                  const Text(
                    'Destaques em Números',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.copper_spice,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            CustomColors.copper_spice.withOpacity(0.4),
                            CustomColors.copper_spice.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const MetricHighlightsWidget(isDesktop: true),
            ],
          ),
        ),
      ),
    );
  }
}
