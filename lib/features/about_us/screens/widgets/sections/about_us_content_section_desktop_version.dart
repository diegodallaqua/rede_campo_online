import 'package:flutter/material.dart';

import '../../../../../core/ui/theme/custom_colors.dart';

class AboutUsContentSectionDesktopVersion extends StatelessWidget {
  const AboutUsContentSectionDesktopVersion({super.key});

  static const String _summaryText =
      'Quem nos separará do amor de Cristo? A tribulação, ou a angústia, ou a perseguição, ou a fome, ou a nudez, ou o perigo, ou a espada? Como está escrito: Por amor de ti somos entregues à morte todo o dia; fomos reputados como ovelhas para o matadouro. Mas em todas estas coisas somos mais do que vencedores, por aquele que nos amou. Porque estou certo de que, nem a morte, nem a vida, nem os anjos, nem os principados, nem as potestades, nem o presente, nem o porvir, nem a altura, nem a profundidade, nem alguma outra criatura nos poderá separar do amor de Deus, que está em Cristo Jesus nosso Senhor.';

  static const String _missionText =
      'Confia no Senhor de todo o teu coração, e não te estribes no teu próprio entendimento. Reconhece-o em todos os teus caminhos, e ele endireitará as tuas veredas.';

  static const String _visionText =
      'Ora, a fé é o firme fundamento das coisas que se esperam, e a prova das coisas que se não veem. Porque por ela os antigos alcançaram testemunho.';

  static const String _valuesText =
      'Não estejais inquietos por coisa alguma; antes as vossas petições sejam em tudo conhecidas diante de Deus, pela oração e súplica, com ação de graças. E a paz de Deus, que excede todo o entendimento, guardará os vossos corações e os vossos sentimentos em Cristo Jesus.';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 48, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _summaryText,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  height: 1.8,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 56),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: _MvvCard(title: 'Missão', body: _missionText)),
                  _VerticalDivider(),
                  Expanded(child: _MvvCard(title: 'Visão', body: _visionText)),
                  _VerticalDivider(),
                  Expanded(
                      child: _MvvCard(title: 'Valores', body: _valuesText)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MvvCard extends StatelessWidget {
  final String title;
  final String body;

  const _MvvCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            body,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 80,
      color: CustomColors.fresh_sprout.withOpacity(0.35),
    );
  }
}
