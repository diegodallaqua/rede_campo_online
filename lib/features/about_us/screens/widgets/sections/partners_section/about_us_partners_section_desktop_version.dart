import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';

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

  static const double _cardHeight = 104.0;
  static const double _separatorHeight = 14.0;
  static const double _listHeight = 3 * _cardHeight + 2 * _separatorHeight;

  static const List<_PartnerData> _partners = [
    _PartnerData(
      logoPath: 'assets/images/idr.png',
      name: 'IDR-Paraná',
      description:
          'Instituto de Desenvolvimento Rural do Paraná, órgão estadual que une extensão rural, pesquisa agrícola e desenvolvimento agrário.',
      url: 'https://www.idrparana.pr.gov.br/',
    ),
    _PartnerData(
      logoPath: 'assets/images/utfpr.png',
      name: 'UTFPR',
      description:
          'Universidade Tecnológica Federal do Paraná, instituição pública voltada ao ensino superior tecnológico, engenharias e pesquisa.',
      url: 'https://www.utfpr.edu.br/',
    ),
    _PartnerData(
      logoPath: 'assets/images/senar.png',
      name: 'SENAR PARANÁ',
      description:
          'Serviço Nacional de Aprendizagem Rural do Paraná, focado na capacitação profissional e assistência técnica do produtor rural.',
      url: 'https://www.sistemafaep.org.br/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
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

  Future<void> _openSite() async {
    final uri = Uri.parse(partner.url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: CustomColors.salt_flower,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CustomColors.soft_border),
        boxShadow: [
          BoxShadow(
            color: CustomColors.midnight_slate.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openSite,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 5,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      CustomColors.copper_spice,
                      CustomColors.fresh_sprout
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 120,
                height: 84,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CustomColors.soft_border),
                ),
                child: Image.asset(
                  partner.logoPath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        partner.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: CustomColors.pine_shadow,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        partner.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontStyle: FontStyle.italic,
                          color: CustomColors.pine_shadow.withOpacity(0.65),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.north_east_rounded,
                  size: 18,
                  color: CustomColors.copper_spice,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PartnerData {
  final String logoPath;
  final String name;
  final String description;
  final String url;

  const _PartnerData({
    required this.logoPath,
    required this.name,
    required this.description,
    required this.url,
  });
}
