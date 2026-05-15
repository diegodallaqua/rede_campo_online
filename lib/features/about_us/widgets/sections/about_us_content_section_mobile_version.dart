import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

class AboutUsContentSectionMobileVersion extends StatelessWidget {
  const AboutUsContentSectionMobileVersion({super.key});

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
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 32, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _summaryText,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.7,
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 38),
          Text(
            'Missão',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
          ),
          SizedBox(height: 16),
          Text(
            _missionText,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Divider(color: CustomColors.fresh_sprout, thickness: 0.5),
          SizedBox(height: 18),
          Text(
            'Visão',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
          ),
          SizedBox(height: 16),
          Text(
            _visionText,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Divider(color: CustomColors.fresh_sprout, thickness: 0.5),
          SizedBox(height: 18),
          Text(
            'Valores',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
            ),
          ),
          SizedBox(height: 16),
          Text(
            _valuesText,
            style: TextStyle(
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
