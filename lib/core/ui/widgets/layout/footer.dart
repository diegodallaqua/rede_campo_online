import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../utils/external_links.dart';

import '../../theme/custom_colors.dart';
import 'nav_items.dart';

const String _instagramUrl =
    'https://www.instagram.com/rede.campo?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==';
// const String _linkedinUrl = ''; // TODO: adicionar URL do LinkedIn

const String _address = 'Rua Cerejeiras, Sala N1, Campus Santa Helena.\n'
    'Prédio da Universidade Tecnológica Federal do Paraná\n'
    'Santa Helena - PR';
const String _phoneLabel = '+55 (51) 98243-4348';
const String _phoneUri = 'tel:+5551982434348';
const String _email = 'rede.campo@gmail.com';
const String _copyright = '© 2025 Rede Campo. Todos os direitos reservados.';
const String _credits =
    'CNPJ: 89.737.605/0001-73 – UTFPR  |  Desenvolvido por Diego Lucas Hattori Dallaqua';

final Color _mutedText = CustomColors.midnight_slate.withOpacity(0.85);
final Color _divider = CustomColors.midnight_slate.withOpacity(0.18);
final Border _topBorder = Border(
  top: BorderSide(color: CustomColors.midnight_slate.withOpacity(0.25)),
);

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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: CustomColors.vanilla_haze,
        border: _topBorder,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(48, 56, 48, 24),
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
                          Image.asset(
                            'assets/images/logo.png',
                            height: 80,
                            alignment: Alignment.centerLeft,
                          ),
                          const SizedBox(height: 16),
                          Text(_address, style: _FooterStyles.body),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                    const Expanded(
                      flex: 2,
                      child: _FooterColumn(
                        title: 'Páginas',
                        child: _PageLinks(),
                      ),
                    ),
                    const SizedBox(width: 48),
                    const Expanded(
                      flex: 3,
                      child: _FooterColumn(
                        title: 'Fale conosco',
                        child: _ContactLinks(),
                      ),
                    ),
                    const SizedBox(width: 48),
                    const Expanded(
                      flex: 2,
                      child: _FooterColumn(
                        title: 'Redes sociais',
                        child: _SocialLinks(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Divider(height: 1, thickness: 1, color: _divider),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_copyright, style: _FooterStyles.small),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Text(
                        _credits,
                        style: _FooterStyles.small,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Mobile
class _FooterMobile extends StatelessWidget {
  const _FooterMobile();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: CustomColors.vanilla_haze,
        border: _topBorder,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset('assets/images/logo.png', height: 88),
            ),
            const SizedBox(height: 14),
            Text(_address, style: _FooterStyles.body),
            const SizedBox(height: 28),
            const _FooterColumn(title: 'Páginas', child: _PageLinks()),
            const SizedBox(height: 28),
            const _FooterColumn(title: 'Fale conosco', child: _ContactLinks()),
            const SizedBox(height: 28),
            const _FooterColumn(title: 'Redes sociais', child: _SocialLinks()),
            const SizedBox(height: 28),
            Divider(height: 1, thickness: 1, color: _divider),
            const SizedBox(height: 16),
            Text(
              _copyright,
              style: _FooterStyles.small,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              _credits,
              style: _FooterStyles.small,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Shared
abstract class _FooterStyles {
  static const TextStyle columnTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: CustomColors.copper_spice,
  );
  static const TextStyle link = TextStyle(
    fontSize: 15,
    color: CustomColors.midnight_slate,
    height: 1.3,
  );
  static final TextStyle body = TextStyle(
    fontSize: 14,
    color: _mutedText,
    height: 1.7,
  );
  static final TextStyle small = TextStyle(
    fontSize: 13,
    color: _mutedText,
    height: 1.6,
  );
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final Widget child;

  const _FooterColumn({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: _FooterStyles.columnTitle),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _PageLinks extends StatelessWidget {
  const _PageLinks();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: navItems
          .map((item) => _FooterLink(
                label: item.label,
                onTap: () => context.go(item.route),
              ))
          .toList(),
    );
  }
}

class _ContactLinks extends StatelessWidget {
  const _ContactLinks();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FooterLink(
          label: _phoneLabel,
          icon: Icons.phone_outlined,
          underline: true,
          onTap: () => openExternalUrl(_phoneUri),
        ),
        _FooterLink(
          label: _email,
          icon: Icons.mail_outline_rounded,
          underline: true,
          onTap: () => openExternalUrl('mailto:$_email'),
        ),
      ],
    );
  }
}

class _SocialLinks extends StatelessWidget {
  const _SocialLinks();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SocialIconButton(
          icon: FontAwesomeIcons.instagram,
          tooltip: 'Instagram da Rede Campo',
          onTap: () => openExternalUrl(_instagramUrl),
        ),
        /*const SizedBox(width: 12),
        _SocialIconButton(
          icon: FontAwesomeIcons.linkedinIn,
          tooltip: 'LinkedIn da Rede Campo',
          onTap: () => openExternalUrl(_linkedinUrl),
        ),*/
      ],
    );
  }
}

/// Link de texto do rodapé com área de toque de 40px de altura.
class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool underline;

  const _FooterLink({
    required this.label,
    required this.onTap,
    this.icon,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      hoverColor: CustomColors.honey_cream.withOpacity(0.35),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 40),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: CustomColors.copper_spice),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                style: _FooterStyles.link.copyWith(
                  decoration: underline ? TextDecoration.underline : null,
                  decorationColor: CustomColors.midnight_slate.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        hoverColor: CustomColors.honey_cream.withOpacity(0.5),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: CustomColors.midnight_slate.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: FaIcon(icon, size: 20, color: CustomColors.midnight_slate),
        ),
      ),
    );
  }
}
