import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/app/router.dart';

import '../../theme/custom_colors.dart';
import 'nav_items.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key, this.onClose});

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

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
                itemCount: navItems.length,
                separatorBuilder: (_, __) => const Divider(
                  color: CustomColors.copper_spice,
                  height: 1,
                  thickness: 1,
                ),
                itemBuilder: (context, index) {
                  final item = navItems[index];
                  final isActive = item.isActive(currentPath);

                  return Material(
                    color: isActive
                        ? CustomColors.honey_cream.withOpacity(0.5)
                        : Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        onClose?.call();
                        context.go(item.route);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Text(
                          item.label,
                          style: TextStyle(
                            color: isActive
                                ? CustomColors.copper_spice
                                : CustomColors.midnight_slate,
                            fontSize: 16,
                            fontWeight:
                                isActive ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(
                color: CustomColors.copper_spice, height: 1, thickness: 1),
            GestureDetector(
              onTap: () {
                onClose?.call();
                context.go(AppRoutes.login);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
            ),
          ],
        ),
      ),
    );
  }
}
