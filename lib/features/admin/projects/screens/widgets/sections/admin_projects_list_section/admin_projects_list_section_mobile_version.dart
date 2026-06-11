import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/admin/projects/screens/widgets/listing/admin_projects/admin_projects_list_widget_mobile_version.dart';
import 'package:rede_campo_online/features/admin/projects/stores/admin_projects_store.dart';
import 'package:rede_campo_online/features/projects/models/projects.dart';

class AdminProjectsListSectionMobileVersion extends StatefulWidget {
  final AdminProjectsStore adminProjectsStore;
  final Future<void> Function(Projects? project) onTapProject;

  const AdminProjectsListSectionMobileVersion({
    super.key,
    required this.adminProjectsStore,
    required this.onTapProject,
  });

  @override
  State<AdminProjectsListSectionMobileVersion> createState() =>
      _AdminProjectsListSectionMobileVersionState();
}

class _AdminProjectsListSectionMobileVersionState
    extends State<AdminProjectsListSectionMobileVersion> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    widget.adminProjectsStore.filterStore.setSearch(value);
    widget.adminProjectsStore.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
          child: AdminProjectsListWidgetMobileVersion(
            adminProjectsStore: widget.adminProjectsStore,
            onTapProject: widget.onTapProject,
          ),
        ),
      ],
    );
  }
}
