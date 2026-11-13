import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/global/injection.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/features/admin/stores/admin_store.dart';

import 'admin_dashboard_desktop_version.dart' show adminGreeting;
import 'admin_sections_grid.dart';

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
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adminGreeting(store.userName),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.pine_shadow,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'O que você quer publicar hoje?',
                    style: TextStyle(
                      fontSize: 14,
                      color: CustomColors.pine_shadow.withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const AdminSectionsGrid(),
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
