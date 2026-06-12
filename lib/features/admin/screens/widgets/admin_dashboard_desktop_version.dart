import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/global/injection.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/features/admin/screens/widgets/admin_sidebar.dart';
import 'package:rede_campo_online/features/admin/stores/admin_store.dart';

class AdminDashboardDesktopVersion extends StatelessWidget {
  const AdminDashboardDesktopVersion({super.key});

  @override
  Widget build(BuildContext context) {
    final store = getIt<AdminStore>();

    return Observer(
      builder: (_) => Row(
        children: [
          AdminSidebar(store: store),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Painel Administrativo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.pine_shadow,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecione uma ação para continuar.',
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomColors.pine_shadow.withOpacity(0.55),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      _DesktopActionCard(
                        icon: Icons.article_outlined,
                        iconColor: CustomColors.copper_spice,
                        iconBackground: CustomColors.peach_cream,
                        title: 'Gerenciar Notícias',
                        description: 'Edite, apague ou publique notícias.',
                        onTap: () => context.push(AppRoutes.adminNews),
                      ),
                      const SizedBox(width: 16),
                      _DesktopActionCard(
                        icon: Icons.science_outlined,
                        iconColor: CustomColors.copper_spice,
                        iconBackground: CustomColors.peach_cream,
                        title: 'Gerenciar Projetos',
                        description: 'Cadastre, edite ou apague projetos.',
                        onTap: () => context.push(AppRoutes.adminProjects),
                      ),
                      const SizedBox(width: 16),
                      _DesktopActionCard(
                        icon: Icons.event_outlined,
                        iconColor: CustomColors.copper_spice,
                        iconBackground: CustomColors.peach_cream,
                        title: 'Gerenciar Eventos',
                        description: 'Cadastre, edite ou apague eventos.',
                        onTap: () => context.push(AppRoutes.adminEvents),
                      ),
                      const SizedBox(width: 16),
                      _DesktopActionCard(
                        icon: Icons.menu_book_outlined,
                        iconColor: CustomColors.copper_spice,
                        iconBackground: CustomColors.peach_cream,
                        title: 'Gerenciar Publicações',
                        description: 'Cadastre, edite ou apague publicações.',
                        onTap: () => context.push(AppRoutes.adminPublications),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopActionCard extends StatelessWidget {
  const _DesktopActionCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E8DC)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: CustomColors.midnight_slate,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: CustomColors.midnight_slate.withOpacity(0.55),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
