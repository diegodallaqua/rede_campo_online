import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/global/injection.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/features/admin/screens/widgets/admin_sidebar.dart';
import 'package:rede_campo_online/features/admin/stores/admin_store.dart';

/// Estrutura desktop do painel: sidebar à esquerda e conteúdo à direita.
class AdminDesktopShell extends StatelessWidget {
  const AdminDesktopShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CustomColors.vanilla_haze.withOpacity(0.5),
      child: Row(
        // Estica na altura: conteúdo curto começa no topo.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Observer(
            builder: (_) => AdminSidebar(store: getIt<AdminStore>()),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
