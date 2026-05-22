import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/projects/project_tile_mobile_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/arrow_button.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';
import 'package:rede_campo_online/features/projects/models/project_media.dart';
import 'package:rede_campo_online/features/projects/models/projects.dart';
import 'package:rede_campo_online/features/projects/repositories/project_media_repository.dart';
import 'package:rede_campo_online/features/projects/stores/projects_store.dart';

class ProjectsListWidgetMobileVersion extends StatefulWidget {
  final ProjectsStore projectsStore;
  final int maxDiscoveredPage;
  final ValueChanged<int> onPageDiscovered;

  const ProjectsListWidgetMobileVersion({
    super.key,
    required this.projectsStore,
    required this.maxDiscoveredPage,
    required this.onPageDiscovered,
  });

  @override
  State<ProjectsListWidgetMobileVersion> createState() =>
      _ProjectsListWidgetMobileVersionState();
}

class _ProjectsListWidgetMobileVersionState
    extends State<ProjectsListWidgetMobileVersion> {
  late final Future<Map<int, ProjectMedia>> _mediaFuture;

  @override
  void initState() {
    super.initState();
    _mediaFuture = _loadMedia();
  }

  Future<Map<int, ProjectMedia>> _loadMedia() async {
    try {
      final mediaList = await ProjectMediaRepository().findAll();
      final map = <int, ProjectMedia>{};
      for (final m in mediaList) {
        final projectId = m.project?.id;
        if (projectId != null && !map.containsKey(projectId)) {
          map[projectId] = m;
        }
      }
      return map;
    } catch (e, s) {
      log('ProjectsListWidgetMobile: erro ao carregar media', error: e, stackTrace: s);
      return {};
    }
  }

  void _notifyPageDiscovered(int discovered) {
    if (discovered > widget.maxDiscoveredPage) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        widget.onPageDiscovered(discovered);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (!widget.projectsStore.loading &&
            widget.projectsStore.list.isNotEmpty) {
          final discovered = widget.projectsStore.page +
              (widget.projectsStore.lastPage ? 0 : 1);
          _notifyPageDiscovered(discovered);
        }

        final showPagination = widget.projectsStore.list.isNotEmpty &&
            (!widget.projectsStore.lastPage ||
                widget.projectsStore.page > 1 ||
                widget.maxDiscoveredPage > 1);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.projectsStore.showProgress)
              const ListLoadingState()
            else if (widget.projectsStore.error != null &&
                widget.projectsStore.list.isEmpty)
              ListErrorState(
                message: 'Não foi possível carregar os projetos.',
                onRetry: widget.projectsStore.refreshData,
                iconColor: CustomColors.copper_spice,
                messageColor: CustomColors.vanilla_haze,
              )
            else if (widget.projectsStore.list.isEmpty)
              const ListEmptyState(
                message: 'Nenhum projeto encontrado.',
              )
            else
              _buildList(),
            if (showPagination) ...[
              const SizedBox(height: 24),
              _buildPageCarousel(),
            ],
          ],
        );
      },
    );
  }

  Widget _buildList() {
    final projects = widget.projectsStore.list;
    return FutureBuilder<Map<int, ProjectMedia>>(
      future: _mediaFuture,
      builder: (context, snapshot) {
        final mediaMap = snapshot.data ?? {};
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: projects.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final project = projects[index];
            return ProjectTileMobileVersion(
              project: project,
              projectMedia: project.id != null ? mediaMap[project.id] : null,
              onTap: () => _onProjectTap(project),
            );
          },
        );
      },
    );
  }

  void _onProjectTap(Projects project) {
    context.push('/projects/${project.id}', extra: project);
  }

  Widget _buildPageCarousel() {
    final currentPage = widget.projectsStore.page;
    final isLastPage = widget.projectsStore.lastPage;
    final isLoading = widget.projectsStore.loading;

    final knownFromStore = isLastPage ? currentPage : currentPage + 1;
    final effectiveMaxPage = widget.maxDiscoveredPage > knownFromStore
        ? widget.maxDiscoveredPage
        : knownFromStore;

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ArrowButton(
              icon: Icons.chevron_left_rounded,
              enabled: !isLoading && currentPage > 1,
              onTap: () => widget.projectsStore.goToPage(currentPage - 1),
              iconColor: CustomColors.midnight_slate,
              disabledIconColor: CustomColors.concrete_mist,
              backgroundColor: Colors.white,
              iconSize: 18,
              borderRadius: 12,
              border: Border.all(color: CustomColors.concrete_mist),
              fixedSize: 33,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              useRipple: false,
            ),
            ...List.generate(effectiveMaxPage, (index) {
              final page = index + 1;
              return _PageNumberButton(
                page: page,
                isActive: page == currentPage,
                enabled: !isLoading,
                onTap: () => widget.projectsStore.goToPage(page),
              );
            }),
            if (!isLastPage)
              ArrowButton(
                icon: Icons.chevron_right_rounded,
                enabled: !isLoading,
                onTap: () => widget.projectsStore.goToPage(currentPage + 1),
                iconColor: CustomColors.midnight_slate,
                disabledIconColor: CustomColors.concrete_mist,
                backgroundColor: Colors.white,
                iconSize: 18,
                borderRadius: 12,
                border: Border.all(color: CustomColors.concrete_mist),
                fixedSize: 33,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                useRipple: false,
              ),
          ],
        ),
      ),
    );
  }
}

class _PageNumberButton extends StatelessWidget {
  final int page;
  final bool isActive;
  final bool enabled;
  final VoidCallback onTap;

  const _PageNumberButton({
    required this.page,
    required this.isActive,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: enabled && !isActive ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? CustomColors.fresh_sprout : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? CustomColors.fresh_sprout
                  : CustomColors.concrete_mist,
            ),
          ),
          child: Center(
            child: Text(
              '$page',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                color: isActive
                    ? Colors.white
                    : enabled
                        ? CustomColors.midnight_slate
                        : CustomColors.concrete_mist,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
