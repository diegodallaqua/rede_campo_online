import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/projects/stores/projects_store.dart';
import '../../listing/projects/projects_list_widget_mobile_version.dart';

class ProjectsListSectionMobileVersion extends StatefulWidget {
  final ProjectsStore projectsStore;

  const ProjectsListSectionMobileVersion({
    super.key,
    required this.projectsStore,
  });

  @override
  State<ProjectsListSectionMobileVersion> createState() =>
      _ProjectsListSectionMobileVersionState();
}

class _ProjectsListSectionMobileVersionState
    extends State<ProjectsListSectionMobileVersion> {
  final TextEditingController _searchController = TextEditingController();
  int _maxDiscoveredPage = 1;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    widget.projectsStore.filterStore.setSearch(value);
    widget.projectsStore.refreshData();
    setState(() => _maxDiscoveredPage = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomSearchBar(
            controller: _searchController,
            onSubmitted: _onSearch,
          ),
          const SizedBox(height: 16),
          ProjectsListWidgetMobileVersion(
            projectsStore: widget.projectsStore,
            maxDiscoveredPage: _maxDiscoveredPage,
            onPageDiscovered: (newMax) {
              if (newMax != _maxDiscoveredPage) {
                setState(() => _maxDiscoveredPage = newMax);
              }
            },
          ),
        ],
      ),
    );
  }
}
