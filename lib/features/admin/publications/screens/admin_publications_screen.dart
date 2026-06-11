import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_mobile_page_scaffold.dart';
import 'package:rede_campo_online/features/admin/screens/widgets/admin_desktop_shell.dart';
import 'package:rede_campo_online/features/admin/publications/screens/widgets/listing/admin_publications_list_desktop.dart';
import 'package:rede_campo_online/features/admin/publications/screens/widgets/listing/admin_publications_list_mobile.dart';
import 'package:rede_campo_online/features/admin/publications/stores/admin_publications_store.dart';
import 'package:rede_campo_online/features/publications/models/publications.dart';

class AdminPublicationsScreen extends StatefulWidget {
  const AdminPublicationsScreen({super.key});

  @override
  State<AdminPublicationsScreen> createState() =>
      _AdminPublicationsScreenState();
}

class _AdminPublicationsScreenState extends State<AdminPublicationsScreen> {
  final _adminPublicationsStore = AdminPublicationsStore();

  Future<void> _navigateToEdit(Publications? publication) async {
    await context.push(AppRoutes.adminCreatePublication, extra: publication);
    _adminPublicationsStore.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToEdit(null),
        backgroundColor: CustomColors.copper_spice,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, size: 22),
        label: const Text(
          'Nova Publicação',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: _buildMobile(context),
        child: _buildDesktop(context),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return AdminDesktopShell(
      child: AdminPublicationsListDesktop(
        adminPublicationsStore: _adminPublicationsStore,
        onTapPublication: _navigateToEdit,
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return AdminMobilePageScaffold(
      title: 'Gerenciar Publicações',
      subtitle: 'Selecione uma publicação para editar.',
      onBack: () => context.pop(),
      child: AdminPublicationsListMobile(
        adminPublicationsStore: _adminPublicationsStore,
        onTapPublication: _navigateToEdit,
      ),
    );
  }
}
