import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/global/injection.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_section_header.dart';
import 'package:rede_campo_online/features/admin/stores/admin_store.dart';

import 'admin_desktop_shell.dart';
import 'admin_sections_grid.dart';

class AdminDashboardDesktopVersion extends StatelessWidget {
  const AdminDashboardDesktopVersion({super.key});

  @override
  Widget build(BuildContext context) {
    final store = getIt<AdminStore>();

    return AdminDesktopShell(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Observer(
                  builder: (_) => Text(
                    adminGreeting(store.userName),
                    style: AdminHeaderStyles.title,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'O que você quer publicar hoje?',
                  style: AdminHeaderStyles.subtitle,
                ),
                const SizedBox(height: 28),
                const AdminSectionsGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "Olá, Ana" a partir do nome completo; só "Olá!" quando não há nome.
String adminGreeting(String fullName) {
  final firstName = fullName.trim().split(RegExp(r'\s+')).first;
  return firstName.isEmpty ? 'Olá!' : 'Olá, $firstName';
}
