import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/app/router.dart';

import '../theme/custom_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width > 768;

    return AppBar(
      backgroundColor: CustomColors.vanilla_haze,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 160,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Image.asset(
          'assets/images/logo_horizontal.png',
          fit: BoxFit.cover,
          alignment: Alignment.centerLeft,
        ),
      ),
      title: isDesktop ? const _DesktopNavLinks() : null,
      centerTitle: false,
      titleSpacing: 8,
      actions: isDesktop
          ? [
              const _LoginButton(),
              const SizedBox(width: 12),
            ]
          : [
              IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: CustomColors.midnight_slate,
                  size: 28,
                ),
                onPressed: onMenuTap,
              ),
              const SizedBox(width: 4),
            ],
    );
  }
}

class _DesktopNavLinks extends StatelessWidget {
  const _DesktopNavLinks();

  static const List<_NavItem> _items = [
    _NavItem(label: 'Início', route: AppRoutes.home),
    _NavItem(label: 'A Rede Campo', route: AppRoutes.aboutUs),
    _NavItem(label: 'Projetos', route: AppRoutes.projects),
    _NavItem(label: 'Publicações', route: AppRoutes.publications),
    _NavItem(label: 'Eventos'),
    _NavItem(label: 'Notícias'),
  ];

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _items
          .map((item) => _NavLink(
                label: item.label,
                route: item.route,
                isActive: item.route != null && item.route == currentPath,
              ))
          .toList(),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final String? route;
  final bool isActive;

  const _NavLink({
    required this.label,
    this.route,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: route != null ? () => context.go(route!) : null,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          isActive ? CustomColors.copper_spice : CustomColors.midnight_slate,
        ),
        overlayColor: MaterialStateProperty.all(
          CustomColors.copper_spice.withOpacity(0.08),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 3),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: isActive ? 18 : 0,
            decoration: BoxDecoration(
              color: CustomColors.copper_spice,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Área do pesquisador',
      child: IconButton(
        icon: const Icon(
          Icons.person_outline_rounded,
          color: CustomColors.midnight_slate,
          size: 26,
        ),
        onPressed: () {
          // TODO: navegar para a tela de login
        },
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String? route;

  const _NavItem({required this.label, this.route});
}
