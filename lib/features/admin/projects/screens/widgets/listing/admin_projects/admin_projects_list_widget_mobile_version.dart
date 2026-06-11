import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/projects/project_tile_mobile_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';
import 'package:rede_campo_online/features/admin/projects/stores/admin_projects_store.dart';
import 'package:rede_campo_online/features/projects/models/projects.dart';

class AdminProjectsListWidgetMobileVersion extends StatefulWidget {
  final AdminProjectsStore adminProjectsStore;
  final Future<void> Function(Projects? project) onTapProject;

  const AdminProjectsListWidgetMobileVersion({
    super.key,
    required this.adminProjectsStore,
    required this.onTapProject,
  });

  @override
  State<AdminProjectsListWidgetMobileVersion> createState() =>
      _AdminProjectsListWidgetMobileVersionState();
}

class _AdminProjectsListWidgetMobileVersionState
    extends State<AdminProjectsListWidgetMobileVersion> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final store = widget.adminProjectsStore;
    if (store.loading || store.lastPage) return;

    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      store.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final store = widget.adminProjectsStore;

        if (store.showProgress) {
          return const Center(child: ListLoadingState());
        } else if (store.error != null && store.list.isEmpty) {
          return Center(
            child: ListErrorState(
              message:
                  store.error ?? 'Não foi possível carregar os projetos.',
              onRetry: store.refreshData,
            ),
          );
        } else if (store.list.isEmpty) {
          return const Center(
            child: ListEmptyState(
              message: 'Nenhum projeto cadastrado.',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: store.refreshData,
          color: CustomColors.copper_spice,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: store.itemCount,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (index >= store.list.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: CustomColors.copper_spice,
                      ),
                    ),
                  ),
                );
              }

              final project = store.list[index];
              return Center(
                child: ProjectTileMobileVersion(
                  project: project,
                  projectMedia: store.mediaMap[project.id],
                  onTap: () => widget.onTapProject(project),
                  isAdmin: true,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
