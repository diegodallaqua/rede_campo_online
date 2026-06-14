import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/global/injection.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_mobile_page_scaffold.dart';
import 'package:rede_campo_online/features/admin/screens/widgets/admin_sidebar.dart';
import 'package:rede_campo_online/features/admin/stores/admin_store.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/members/admin_member_tile.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_entity_list_section.dart';
import 'package:rede_campo_online/features/admin/members/stores/admin_members_store.dart';
import 'package:rede_campo_online/features/members/models/members.dart';

class AdminMembersScreen extends StatefulWidget {
  const AdminMembersScreen({super.key});

  @override
  State<AdminMembersScreen> createState() => _AdminMembersScreenState();
}

class _AdminMembersScreenState extends State<AdminMembersScreen> {
  final _adminMembersStore = AdminMembersStore();

  // Cartão horizontal denso: no desktop a grade usa células largas; no mobile
  // a listagem cai para uma lista vertical de cartões em largura total.
  static const _desktopGrid = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 440,
    crossAxisSpacing: 16,
    mainAxisSpacing: 14,
    mainAxisExtent: 132,
  );

  Future<void> _navigateToEdit(Members? member) async {
    await context.push(AppRoutes.adminCreateMember, extra: member);
    _adminMembersStore.refreshData();
  }

  Widget _buildTile(BuildContext context, Members member) => AdminMemberTile(
        member: member,
        onTap: () => _navigateToEdit(member),
      );

  @override
  Widget build(BuildContext context) {
    final fab = FloatingActionButton.extended(
      onPressed: () => _navigateToEdit(null),
      backgroundColor: CustomColors.copper_spice,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(Icons.add_rounded, size: 22),
      label: const Text(
        'Novo Membro',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );

    return Scaffold(
      floatingActionButton: fab,
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: _buildMobile(context),
        child: _buildDesktop(context),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return ColoredBox(
      color: CustomColors.vanilla_haze.withOpacity(0.5),
      child: Row(
        children: [
          Observer(
            builder: (_) => AdminSidebar(store: getIt<AdminStore>()),
          ),
          Expanded(
            child: AdminEntityListSectionDesktopVersion<Members>(
              store: _adminMembersStore,
              title: 'Gerenciar Membros',
              subtitle: 'Selecione um membro para editar.',
              errorMessage: 'Não foi possível carregar os membros.',
              emptyMessage: 'Nenhum membro cadastrado.',
              gridDelegate: _desktopGrid,
              itemBuilder: _buildTile,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return AdminMobilePageScaffold(
      title: 'Gerenciar Membros',
      subtitle: 'Selecione um membro para editar.',
      onBack: () => context.pop(),
      child: AdminEntityListSectionMobileVersion<Members>(
        store: _adminMembersStore,
        errorMessage: 'Não foi possível carregar os membros.',
        emptyMessage: 'Nenhum membro cadastrado.',
        itemBuilder: _buildTile,
      ),
    );
  }
}
