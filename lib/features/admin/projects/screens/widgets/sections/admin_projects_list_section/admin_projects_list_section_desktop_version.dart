import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/admin/projects/screens/widgets/listing/admin_projects/admin_projects_list_widget_desktop_version.dart';
import 'package:rede_campo_online/features/admin/projects/stores/admin_projects_store.dart';
import 'package:rede_campo_online/features/projects/models/projects.dart';

class AdminProjectsListSectionDesktopVersion extends StatefulWidget {
  final AdminProjectsStore adminProjectsStore;
  final Future<void> Function(Projects? project) onTapProject;

  const AdminProjectsListSectionDesktopVersion({
    super.key,
    required this.adminProjectsStore,
    required this.onTapProject,
  });

  @override
  State<AdminProjectsListSectionDesktopVersion> createState() =>
      _AdminProjectsListSectionDesktopVersionState();
}

class _AdminProjectsListSectionDesktopVersionState
    extends State<AdminProjectsListSectionDesktopVersion> {
  final TextEditingController _searchController = TextEditingController();
  int _maxDiscoveredPage = 1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    widget.adminProjectsStore.filterStore.setSearch(value);
    widget.adminProjectsStore.refreshData();
    setState(() => _maxDiscoveredPage = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_rounded, size: 16),
                label: const Text('Painel Admin'),
                style: TextButton.styleFrom(
                  foregroundColor:
                      CustomColors.midnight_slate.withOpacity(0.50),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Gerenciar Projetos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: CustomColors.pine_shadow,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selecione um projeto para editar.',
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColors.pine_shadow.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
          child: CustomSearchBar(
            controller: _searchController,
            onSubmitted: _onSearch,
            backgroundColor: Colors.white,
            borderColor: CustomColors.concrete_mist,
            textColor: CustomColors.midnight_slate,
            hintColor: CustomColors.midnight_slate.withOpacity(0.45),
            iconColor: CustomColors.copper_spice,
          ),
        ),
        Expanded(
          child: AdminProjectsListWidgetDesktopVersion(
            adminProjectsStore: widget.adminProjectsStore,
            maxDiscoveredPage: _maxDiscoveredPage,
            onPageDiscovered: (newMax) {
              if (newMax != _maxDiscoveredPage) {
                setState(() => _maxDiscoveredPage = newMax);
              }
            },
            onTapProject: widget.onTapProject,
          ),
        ),
      ],
    );
  }
}
