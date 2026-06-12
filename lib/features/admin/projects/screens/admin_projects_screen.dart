import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/global/injection.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/gradient_header.dart';
import 'package:rede_campo_online/features/admin/screens/widgets/admin_sidebar.dart';
import 'package:rede_campo_online/features/admin/stores/admin_store.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/projects/project_tile_desktop_version.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/projects/project_tile_mobile_version.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_entity_list_section.dart';
import 'package:rede_campo_online/features/admin/projects/stores/admin_projects_store.dart';
import 'package:rede_campo_online/features/projects/models/projects.dart';

class AdminProjectsScreen extends StatefulWidget {
  const AdminProjectsScreen({super.key});

  @override
  State<AdminProjectsScreen> createState() => _AdminProjectsScreenState();
}

class _AdminProjectsScreenState extends State<AdminProjectsScreen> {
  final _adminProjectsStore = AdminProjectsStore();

  Future<void> _navigateToEdit(Projects? project) async {
    await context.push(AppRoutes.adminCreateProject, extra: project);
    _adminProjectsStore.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final fab = FloatingActionButton.extended(
      onPressed: () => _navigateToEdit(null),
      backgroundColor: CustomColors.copper_spice,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(Icons.add_rounded, size: 22),
      label: const Text(
        'Novo Projeto',
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
            child: AdminEntityListSectionDesktopVersion<Projects>(
              store: _adminProjectsStore,
              title: 'Gerenciar Projetos',
              subtitle: 'Selecione um projeto para editar.',
              errorMessage: 'Não foi possível carregar os projetos.',
              emptyMessage: 'Nenhum projeto cadastrado.',
              itemBuilder: (context, project) => ProjectTileDesktopVersion(
                project: project,
                projectMedia: _adminProjectsStore.mediaMap[project.id],
                onTap: () => _navigateToEdit(project),
                isAdmin: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
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
        child: Column(
          children: [
            GradientHeader(
              title: 'Gerenciar Projetos',
              subtitle: 'Selecione um projeto para editar.',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: CustomColors.salt_flower,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                clipBehavior: Clip.antiAlias,
                child: AdminEntityListSectionMobileVersion<Projects>(
                  store: _adminProjectsStore,
                  errorMessage: 'Não foi possível carregar os projetos.',
                  emptyMessage: 'Nenhum projeto cadastrado.',
                  itemBuilder: (context, project) => Center(
                    child: ProjectTileMobileVersion(
                      project: project,
                      projectMedia: _adminProjectsStore.mediaMap[project.id],
                      onTap: () => _navigateToEdit(project),
                      isAdmin: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
