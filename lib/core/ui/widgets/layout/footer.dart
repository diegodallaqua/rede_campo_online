import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/custom_colors.dart';

const String _instagramUrl =
    'https://www.instagram.com/rede.campo?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==';
// const String _linkedinUrl = ''; // TODO: adicionar URL do LinkedIn

Future<void> _launchUrl(String url) async {
  if (url.isEmpty) return;
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveVisibility(
      visible: false,
      visibleWhen: [Condition.largerThan(name: TABLET)],
      replacement: _FooterMobile(),
      child: _FooterDesktop(),
    );
  }
}

// Desktop
class _FooterDesktop extends StatelessWidget {
  const _FooterDesktop();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.vanilla_haze,
      padding: const EdgeInsets.fromLTRB(48, 0, 48, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: CustomColors.midnight_slate, thickness: 0.5),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 80,
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Rua Cerejeiras, Sala N1, Campus Santa Helena.\n'
                      'Prédio da Universidade Tecnológica Federal do Paraná\n'
                      'Santa Helena - PR',
                      style: TextStyle(
                        fontSize: 12,
                        color: CustomColors.midnight_slate,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              // Contact
              const Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fale Conosco',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: CustomColors.midnight_slate,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '+55 (51) 98243-4348',
                      style: TextStyle(
                        fontSize: 13,
                        color: CustomColors.midnight_slate,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'E-mail',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: CustomColors.midnight_slate,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'rede.campo@gmail.com',
                      style: TextStyle(
                        fontSize: 13,
                        color: CustomColors.midnight_slate,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
              // Social
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Redes Sociais',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: CustomColors.midnight_slate,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _SocialIconButton(
                          icon: FontAwesomeIcons.instagram,
                          onTap: () => _launchUrl(_instagramUrl),
                        ),
                        /*const SizedBox(width: 16),
                        _SocialIconButton(
                          icon: FontAwesomeIcons.linkedinIn,
                          onTap: () => _launchUrl(_linkedinUrl),
                        ),*/
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Divider(color: CustomColors.midnight_slate, thickness: 0.5),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              '© 2025 Rede Campo. Todos os direitos reservados.',
              style:
                  TextStyle(fontSize: 11, color: CustomColors.midnight_slate),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text(
              'CNPJ: 89.737.605/0001-73 – UTFPR  |  Desenvolvido por Diego Lucas Hattori Dallaqua',
              style: TextStyle(
                fontSize: 11,
                color: CustomColors.midnight_slate,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// Mobile
class _FooterMobile extends StatelessWidget {
  const _FooterMobile();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.vanilla_haze,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: CustomColors.midnight_slate, thickness: 0.5),
          const SizedBox(height: 16),
          Image.asset(
            'assets/images/logo.png',
            height: 100,
            alignment: Alignment.centerLeft,
          ),
          const SizedBox(height: 14),
          const Text(
            'Rua Cerejeiras, Sala N1, Campus Santa Helena.\n'
            'Prédio da Universidade Tecnológica Federal do Paraná | Santa Helena - PR',
            style: TextStyle(
              fontSize: 12,
              color: CustomColors.midnight_slate,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Fale Conosco',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: CustomColors.midnight_slate,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            '+55 (51) 98243-4348',
            style: TextStyle(fontSize: 13, color: CustomColors.midnight_slate),
          ),
          const SizedBox(height: 12),
          const Text(
            'E-mail',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: CustomColors.midnight_slate,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'rede.campo@gmail.com',
            style: TextStyle(fontSize: 13, color: CustomColors.midnight_slate),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _SocialIconButton(
                icon: FontAwesomeIcons.instagram,
                onTap: () => _launchUrl(_instagramUrl),
              ),
              /*const SizedBox(width: 16),
              _SocialIconButton(
                icon: FontAwesomeIcons.linkedinIn,
                onTap: () => _launchUrl(_linkedinUrl),
              ),*/
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: CustomColors.midnight_slate, thickness: 0.5),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              '© 2025 Rede Campo. Todos os direitos reservados.',
              style:
                  TextStyle(fontSize: 11, color: CustomColors.midnight_slate),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text(
              'CNPJ: 89.737.605/0001-73 – UTFPR  |  Desenvolvido por Diego Lucas Hattori Dallaqua',
              style: TextStyle(
                fontSize: 11,
                color: CustomColors.midnight_slate,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// Shared
class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: FaIcon(
          icon,
          size: 28,
          color: CustomColors.midnight_slate,
        ),
      ),
    );
  }
}
