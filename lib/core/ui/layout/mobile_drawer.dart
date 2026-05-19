import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/app/router.dart';

import '../theme/custom_colors.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key, this.onClose});

  final VoidCallback? onClose;

  static const _menuItems = [
    _MenuItem(label: 'Início', route: AppRoutes.home),
    _MenuItem(label: 'A Rede Campo', route: AppRoutes.aboutUs),
    _MenuItem(label: 'Projetos', route: AppRoutes.projects),
    _MenuItem(label: 'Publicações', route: null),
    _MenuItem(label: 'Eventos', route: null),
    _MenuItem(label: 'Notícias', route: null),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CustomColors.vanilla_haze,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Image.asset(
                'assets/images/logo.png',
                height: 64,
                alignment: Alignment.center,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _menuItems.length,
                separatorBuilder: (_, __) => const Divider(
                  color: CustomColors.copper_spice,
                  height: 1,
                  thickness: 1,
                ),
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  return InkWell(
                    onTap: () {
                      onClose?.call();
                      if (item.route != null) {
                        context.go(item.route!);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          color: CustomColors.midnight_slate,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(
                color: CustomColors.copper_spice, height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        color: CustomColors.midnight_slate,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(text: 'É um pesquisador da\nRede '),
                        TextSpan(
                          text: 'Campo',
                          style: TextStyle(color: CustomColors.copper_spice),
                        ),
                        TextSpan(text: '?'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        color: CustomColors.midnight_slate,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(text: 'Clique '),
                        TextSpan(
                          text: 'aqui',
                          style: TextStyle(
                            color: CustomColors.copper_spice,
                            decoration: TextDecoration.underline,
                            decorationColor: CustomColors.copper_spice,
                          ),
                        ),
                        TextSpan(text: ' para fazer login.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final String label;
  final String? route;

  const _MenuItem({required this.label, required this.route});
}
