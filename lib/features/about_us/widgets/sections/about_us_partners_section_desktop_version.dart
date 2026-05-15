import 'package:flutter/material.dart';

import '../../../../core/ui/theme/custom_colors.dart';

class AboutUsPartnersSectionDesktopVersion extends StatefulWidget {
  const AboutUsPartnersSectionDesktopVersion({super.key});

  @override
  State<AboutUsPartnersSectionDesktopVersion> createState() =>
      _AboutUsPartnersSectionDesktopVersionState();
}

class _AboutUsPartnersSectionDesktopVersionState
    extends State<AboutUsPartnersSectionDesktopVersion> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static const double _cardHeight = 80.0;
  static const double _separatorHeight = 12.0;
  static const double _listHeight = 3 * _cardHeight + 2 * _separatorHeight;

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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1440),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
          child: Row(
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
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: CustomColors.fresh_sprout,
                          height: 1.2,
                        ),
                        children: [
                          TextSpan(text: 'Parceiros\nEstratégicos\n'),
                          TextSpan(
                            text: 'da Rede Campo',
                            style: TextStyle(
                              fontSize: 22,
                              color: CustomColors.copper_spice,
                              fontWeight: FontWeight.normal,
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
                        color: CustomColors.fresh_sprout,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                flex: 6,
                child: ConstrainedBox(
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
                      itemBuilder: (context, index) =>
                          _PartnerCard(partner: _partners[index]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PartnerCard extends StatelessWidget {
  final _PartnerData partner;

  const _PartnerCard({required this.partner});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.honey_cream,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CustomColors.midnight_slate.withOpacity(0.10),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Image.asset(
              partner.logoPath,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            width: 1,
            height: 56,
            color: CustomColors.midnight_slate.withOpacity(0.12),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partner.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: CustomColors.pine_shadow,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    partner.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: CustomColors.pine_shadow,
                      height: 1.5,
                    ),
                  ),
                ],
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
