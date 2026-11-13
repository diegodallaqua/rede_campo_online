import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/features/admin/stores/admin_store.dart';
import 'package:url_launcher/url_launcher.dart';

import 'admin_sections.dart';

/// Sidebar desktop do painel: navegação, site público, usuário e saída.
class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key, required this.store});

  final AdminStore store;

  static final Color _muted = CustomColors.vanilla_haze.withOpacity(0.78);

  Future<void> _openPublicSite() async {
    // Abre o site em outra aba para o painel continuar aberto.
    final uri = Uri.base.replace(fragment: AppRoutes.home);
    await launchUrl(uri, webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

    return Container(
      width: 240,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CustomColors.copper_spice, CustomColors.midnight_slate],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -70,
            right: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: CustomColors.vanilla_haze.withOpacity(0.06),
                  width: 40,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/logo_white.png',
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // Rola em janelas baixas; usuário e "Sair" ficam visíveis.
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SidebarItem(
                          icon: Icons.home_outlined,
                          label: 'Início',
                          active: currentPath == AppRoutes.admin,
                          onTap: () => context.go(AppRoutes.admin),
                        ),
                        for (final section in adminSections)
                          _SidebarItem(
                            icon: section.icon,
                            label: section.label,
                            active: section.isActive(currentPath),
                            onTap: () => context.go(section.listRoute),
                          ),
                        const SizedBox(height: 8),
                        _SidebarItem(
                          icon: Icons.open_in_new_rounded,
                          label: 'Ver site',
                          active: false,
                          onTap: _openPublicSite,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.userName,
                        style: const TextStyle(
                          color: CustomColors.vanilla_haze,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (store.roleName.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          store.roleName,
                          style: TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
                Divider(
                  color: CustomColors.vanilla_haze.withOpacity(0.12),
                  height: 1,
                  thickness: 1,
                ),
                TextButton.icon(
                  onPressed: () async {
                    await store.logout();
                    if (context.mounted) context.go(AppRoutes.login);
                  },
                  icon: Icon(Icons.logout_rounded, color: _muted, size: 18),
                  label: Text(
                    'Sair',
                    style: TextStyle(color: _muted, fontSize: 14),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Item de navegação da barra lateral; o ativo ganha fundo claro e negrito.
class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? CustomColors.vanilla_haze : AdminSidebar._muted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      child: Material(
        color: active
            ? CustomColors.vanilla_haze.withOpacity(0.16)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          hoverColor: CustomColors.vanilla_haze.withOpacity(0.08),
          child: SizedBox(
            height: 42,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: color),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 14.5,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
