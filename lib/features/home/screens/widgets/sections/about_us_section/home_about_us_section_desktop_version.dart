import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../app/router.dart';
import '../../../../../../core/ui/buttons/custom_button.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';

class HomeAboutUsSectionDesktopVersion extends StatelessWidget {
  const HomeAboutUsSectionDesktopVersion({super.key});

  static const String _aboutText =
      'A Rede Campo nasceu de uma pergunta simples: o que acontece quando a universidade vai até o campo, não só para estudar, mas para construir junto? Criada em 2021 e vinculada à UTFPR Campus Santa Helena, somos um grupo de pesquisadores e extensionistas que acreditam que o conhecimento científico só faz sentido pleno quando chega a quem precisa dele. Por isso, nossa atuação vai além dos laboratórios e artigos acadêmicos: estamos nas propriedades rurais, nas comunidades, nas conversas que transformam teoria em prática. Trabalhamos na interseção entre ciência e território, desenvolvendo tecnologias aplicadas ao desenvolvimento rural sustentável e compartilhando esses resultados de forma aberta e acessível. Aqui você encontra nossas pesquisas, projetos de extensão, publicações e muito do que produzimos em parceria com agricultores, organizações e comunidades da região.';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 56, 48, 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sobre nós',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: CustomColors.fresh_sprout,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 64,
                height: 3,
                decoration: BoxDecoration(
                  color: CustomColors.fresh_sprout,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                _aboutText,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.9,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 36),
              Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  width: 180,
                  color: CustomColors.concrete_mist,
                  text: 'Saiba mais',
                  textColor: CustomColors.midnight_slate,
                  borderRadius: 12,
                  fontWeight: FontWeight.w700,
                  function: () => context.go(AppRoutes.aboutUs),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
