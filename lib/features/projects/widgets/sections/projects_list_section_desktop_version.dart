import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/projects/stores/projects_store.dart';
import '../../../../core/ui/theme/custom_colors.dart';
import '../listing/projects_list_widget_desktop_version.dart';

class ProjectsListSectionDesktopVersion extends StatefulWidget {
  final ProjectsStore projectsStore;

  const ProjectsListSectionDesktopVersion(
      {super.key, required this.projectsStore});

  @override
  State<ProjectsListSectionDesktopVersion> createState() =>
      _ProjectsListSectionDesktopVersionState();
}

class _ProjectsListSectionDesktopVersionState
    extends State<ProjectsListSectionDesktopVersion> {
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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Projetos',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: CustomColors.fresh_sprout,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 64,
                          height: 3,
                          decoration: BoxDecoration(
                            color: CustomColors.fresh_sprout,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: CustomSearchBar(
                        controller: _searchController,
                        onSubmitted: _onSearch,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ProjectsListWidgetDesktopVersion(
                projectsStore: widget.projectsStore,
                maxDiscoveredPage: _maxDiscoveredPage,
                onPageDiscovered: (newMax) {
                  if (newMax > _maxDiscoveredPage) {
                    setState(() => _maxDiscoveredPage = newMax);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
