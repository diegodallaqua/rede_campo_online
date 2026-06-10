import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/features/admin/stores/admin_store.dart';

/// Gradient branding panel shown on the left of every desktop admin screen,
/// mirroring the LoginScreen branding panel (copper → midnight gradient with
/// decorative circles, logo, user info and logout).
class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key, required this.store});

  final AdminStore store;

  @override
  Widget build(BuildContext context) {
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
          Positioned(
            bottom: 130,
            right: -24,
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: CustomColors.vanilla_haze.withOpacity(0.09),
                  width: 18,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/logo_white.png',
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Spacer(),
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
                          style: TextStyle(
                            color: CustomColors.vanilla_haze.withOpacity(0.60),
                            fontSize: 12,
                          ),
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
                  icon: Icon(
                    Icons.logout_rounded,
                    color: CustomColors.vanilla_haze.withOpacity(0.65),
                    size: 18,
                  ),
                  label: Text(
                    'Sair',
                    style: TextStyle(
                      color: CustomColors.vanilla_haze.withOpacity(0.65),
                      fontSize: 14,
                    ),
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
