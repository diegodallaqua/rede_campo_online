import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/global/injection.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/features/admin/stores/admin_store.dart';

class AdminDashboardMobileVersion extends StatelessWidget {
  const AdminDashboardMobileVersion({super.key});

  @override
  Widget build(BuildContext context) {
    final store = getIt<AdminStore>();

    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AdminHeader(store: store),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'O que deseja fazer?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: CustomColors.midnight_slate,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _AdminActionCard(
                    icon: Icons.article_outlined,
                    iconColor: CustomColors.copper_spice,
                    iconBackground: CustomColors.peach_cream,
                    title: 'Gerenciar Notícias',
                    description: 'Edite, apague ou publique notícias no site.',
                    onTap: () => context.push(AppRoutes.adminNews),
                  ),
                  const SizedBox(height: 14),
                  _AdminActionCard(
                    icon: Icons.science_outlined,
                    iconColor: CustomColors.copper_spice,
                    iconBackground: CustomColors.peach_cream,
                    title: 'Gerenciar Projetos',
                    description: 'Cadastre, edite ou apague projetos do site.',
                    onTap: () => context.push(AppRoutes.adminProjects),
                  ),
                  const SizedBox(height: 14),
                  _AdminActionCard(
                    icon: Icons.event_outlined,
                    iconColor: CustomColors.copper_spice,
                    iconBackground: CustomColors.peach_cream,
                    title: 'Gerenciar Eventos',
                    description: 'Cadastre, edite ou apague eventos do site.',
                    onTap: () => context.push(AppRoutes.adminEvents),
                  ),
                  const SizedBox(height: 14),
                  _AdminActionCard(
                    icon: Icons.menu_book_outlined,
                    iconColor: CustomColors.copper_spice,
                    iconBackground: CustomColors.peach_cream,
                    title: 'Gerenciar Publicações',
                    description:
                        'Cadastre, edite ou apague publicações do site.',
                    onTap: () => context.push(AppRoutes.adminPublications),
                  ),
                  const SizedBox(height: 14),
                  _AdminActionCard(
                    icon: Icons.groups_outlined,
                    iconColor: CustomColors.copper_spice,
                    iconBackground: CustomColors.peach_cream,
                    title: 'Gerenciar Membros',
                    description: 'Cadastre, edite ou apague membros do site.',
                    onTap: () => context.push(AppRoutes.adminMembers),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminHeader extends StatelessWidget {
  const _AdminHeader({required this.store});

  final AdminStore store;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CustomColors.copper_spice, CustomColors.midnight_slate],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 20),
          child: Row(
            children: [
              _UserAvatar(name: store.userName),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.userName,
                      style: const TextStyle(
                        color: CustomColors.vanilla_haze,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (store.roleName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        store.roleName,
                        style: TextStyle(
                          color: CustomColors.vanilla_haze.withOpacity(0.60),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Sair',
                icon: Icon(
                  Icons.logout_rounded,
                  color: CustomColors.vanilla_haze.withOpacity(0.75),
                  size: 22,
                ),
                onPressed: () async {
                  await store.logout();
                  if (context.mounted) context.go(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.name});

  final String name;

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: CustomColors.vanilla_haze.withOpacity(0.18),
        shape: BoxShape.circle,
        border: Border.all(
          color: CustomColors.vanilla_haze.withOpacity(0.35),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          _initials,
          style: const TextStyle(
            color: CustomColors.vanilla_haze,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _AdminActionCard extends StatelessWidget {
  const _AdminActionCard({
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8E8DC)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: CustomColors.midnight_slate,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: CustomColors.midnight_slate.withOpacity(0.55),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: CustomColors.midnight_slate.withOpacity(0.30),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
