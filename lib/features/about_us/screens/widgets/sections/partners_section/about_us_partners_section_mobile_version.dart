import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

import '../../listing/partners/about_us_partners_tile_mobile_version.dart';

class AboutUsPartnersSectionMobileVersion extends StatefulWidget {
  const AboutUsPartnersSectionMobileVersion({super.key});

  @override
  State<AboutUsPartnersSectionMobileVersion> createState() =>
      _AboutUsPartnersSectionMobileVersionState();
}

class _AboutUsPartnersSectionMobileVersionState
    extends State<AboutUsPartnersSectionMobileVersion> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static const String _partnersText =
      'Não sabes, não ouviste que o Senhor é o Deus eterno, criador dos fins da terra? Ele não se cansa nem se fatiga, e a sua sabedoria é insondável. Dá força ao cansado, e multiplica as forças ao que não tem nenhum vigor. Os jovens se cansarão e se fatigarão, os moços certamente cairão; mas os que esperam no Senhor renovarão as suas forças; subirão com asas como águias; correrão, e não se cansarão; caminharão, e não se fatigarão.';

  static const double _tileHeight = 72.0;
  static const double _separatorHeight = 12.0;
  static const double _listHeight = 3 * _tileHeight + 2 * _separatorHeight;

  static const List<_PartnerData> _partners = [
    _PartnerData(
      logoPath: 'assets/images/idr.png',
      name: 'IDR-Paraná',
      description: 'O Senhor é o meu pastor; nada me faltará.',
    ),
    _PartnerData(
      logoPath: 'assets/images/utfpr.png',
      name: 'UTFPR',
      description: 'Tudo posso naquele que me fortalece.',
    ),
    _PartnerData(
      logoPath: 'assets/images/senar.png',
      name: 'SENAR PARANÁ',
      description:
          'Sabemos que todas as coisas cooperam para o bem daqueles que amam a Deus.',
    ),
  ];

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
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
              children: [
                TextSpan(text: 'Parceiros Estratégicos\n'),
                TextSpan(
                  text: 'da Rede Campo',
                  style: TextStyle(
                    color: CustomColors.copper_spice,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            _partnersText,
            style: TextStyle(
              fontSize: 14,
              color: CustomColors.pine_shadow,
              height: 1.7,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 28),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: _listHeight),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: ListView.separated(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                itemCount: _partners.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: _separatorHeight),
                itemBuilder: (context, index) {
                  final partner = _partners[index];
                  return AboutUsPartnersTileMobileVersion(
                    logoPath: partner.logoPath,
                    name: partner.name,
                    description: partner.description,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerData {
  final String logoPath;
  final String name;
  final String description;

  const _PartnerData({
    required this.logoPath,
    required this.name,
    required this.description,
  });
}
