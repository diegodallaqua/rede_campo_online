import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/projects/project_tile_mobile_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_create_fab.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_entity_list_section.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_mobile_page_scaffold.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_table.dart';
import 'package:rede_campo_online/core/utils/admin_navigation.dart';
import 'package:rede_campo_online/features/admin/projects/stores/admin_projects_store.dart';
import 'package:rede_campo_online/features/admin/screens/widgets/admin_desktop_shell.dart';
import 'package:rede_campo_online/features/projects/models/projects.dart';

class AdminProjectsScreen extends StatefulWidget {
  const AdminProjectsScreen({super.key});

  @override
  State<AdminProjectsScreen> createState() => _AdminProjectsScreenState();
}

class _AdminProjectsScreenState extends State<AdminProjectsScreen> {
  final _adminProjectsStore = AdminProjectsStore();

  static const _errorMessage = 'Não foi possível carregar os projetos.';
  static const _emptyMessage = 'Nenhum projeto cadastrado.';
  static const _searchHint = 'Pesquisar projetos';

  static const _columns = [
    AdminTableColumn('', width: 56),
    AdminTableColumn('Título'),
    AdminTableColumn('Status', width: 110),
    AdminTableColumn('Áreas de pesquisa', width: 280),
  ];

  Future<void> _openForm([Projects? project]) async {
    await openAdminForm(context, AppRoutes.adminCreateProject, extra: project);
    _adminProjectsStore.refreshData();
  }

  List<Widget> _cells(Projects project) => [
        AdminTableThumb(
          imageUrl: _adminProjectsStore.mediaMap[project.id]?.media,
        ),
        AdminTableTitle(
          title: project.name ?? '-',
          subtitle: project.description,
        ),
        AdminTableChips(
          labels: [project.status == true ? 'Ativo' : 'Inativo'],
          color: project.status == true
              ? CustomColors.pine_shadow
              : CustomColors.neutral_gray,
        ),
        AdminTableChips(
          labels:
              (project.research_areas ?? []).map((a) => a.name ?? '').toList(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AdminCreateFab.isVisible(context)
          ? AdminCreateFab(label: 'Novo Projeto', onPressed: _openForm)
          : null,
      body: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: TABLET)],
        replacement: AdminMobilePageScaffold(
          title: 'Gerenciar Projetos',
          subtitle: 'Selecione um projeto para editar.',
          onBack: () => closeAdminPage(context, AppRoutes.admin),
          child: AdminEntityListSectionMobileVersion<Projects>(
            store: _adminProjectsStore,
            errorMessage: _errorMessage,
            emptyMessage: _emptyMessage,
            searchHint: _searchHint,
            itemBuilder: (context, project) => ProjectTileMobileVersion(
              project: project,
              projectMedia: _adminProjectsStore.mediaMap[project.id],
              onTap: () => _openForm(project),
              isAdmin: true,
            ),
          ),
        ),
        child: AdminDesktopShell(
          child: AdminEntityListSectionDesktopVersion<Projects>(
            store: _adminProjectsStore,
            title: 'Projetos',
            subtitle: 'Clique em uma linha para editar.',
            searchHint: _searchHint,
            errorMessage: _errorMessage,
            emptyMessage: _emptyMessage,
            createLabel: 'Novo projeto',
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
