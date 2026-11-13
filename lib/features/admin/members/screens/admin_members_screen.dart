import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/members/admin_member_tile.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_create_fab.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_entity_list_section.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_mobile_page_scaffold.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_table.dart';
import 'package:rede_campo_online/core/utils/admin_navigation.dart';
import 'package:rede_campo_online/features/admin/members/stores/admin_members_store.dart';
import 'package:rede_campo_online/features/admin/screens/widgets/admin_desktop_shell.dart';
import 'package:rede_campo_online/features/members/models/members.dart';

class AdminMembersScreen extends StatefulWidget {
  const AdminMembersScreen({super.key});

  @override
  State<AdminMembersScreen> createState() => _AdminMembersScreenState();
}

class _AdminMembersScreenState extends State<AdminMembersScreen> {
  final _adminMembersStore = AdminMembersStore();

  static const _errorMessage = 'Não foi possível carregar os membros.';
  static const _emptyMessage = 'Nenhum membro cadastrado.';
  static const _searchHint = 'Pesquisar membros';

  static const _columns = [
    AdminTableColumn('', width: 40),
    AdminTableColumn('Nome'),
    AdminTableColumn('Papel', width: 180),
    AdminTableColumn('Organização', width: 220),
  ];

  Future<void> _openForm([Members? member]) async {
    await openAdminForm(context, AppRoutes.adminCreateMember, extra: member);
    _adminMembersStore.refreshData();
  }

  List<Widget> _cells(Members member) => [
        AdminTableAvatar(imageUrl: member.profilePicture, name: member.name),
        AdminTableTitle(title: member.name ?? '-', subtitle: member.email),
        AdminTableChips(
          labels: [member.memberRole?.name ?? ''],
          color: CustomColors.copper_spice,
        ),
        AdminTableText(member.organization?.name),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AdminCreateFab.isVisible(context)
          ? AdminCreateFab(label: 'Novo Membro', onPressed: _openForm)
          : null,
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: AdminMobilePageScaffold(
          title: 'Gerenciar Membros',
          subtitle: 'Selecione um membro para editar.',
          onBack: () => closeAdminPage(context, AppRoutes.admin),
          child: AdminEntityListSectionMobileVersion<Members>(
            store: _adminMembersStore,
            errorMessage: _errorMessage,
            emptyMessage: _emptyMessage,
            searchHint: _searchHint,
            itemBuilder: (context, member) => AdminMemberTile(
              member: member,
              onTap: () => _openForm(member),
            ),
          ),
        ),
        child: AdminDesktopShell(
          child: AdminEntityListSectionDesktopVersion<Members>(
            store: _adminMembersStore,
            title: 'Membros',
            subtitle: 'Clique em uma linha para editar.',
            searchHint: _searchHint,
            errorMessage: _errorMessage,
            emptyMessage: _emptyMessage,
            createLabel: 'Novo membro',
            onCreate: _openForm,
            columns: _columns,
            cellsBuilder: _cells,
            onEdit: _openForm,
          ),
        ),
      ),
    );
  }
}
