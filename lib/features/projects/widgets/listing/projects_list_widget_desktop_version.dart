import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../core/ui/listing_tiles/projects/project_tile_desktop_version.dart';
import '../../../../core/ui/theme/custom_colors.dart';
import '../../../../core/ui/widgets/arrow_button.dart';
import '../../../../core/ui/widgets/list_empty_state.dart';
import '../../../../core/ui/widgets/list_error_state.dart';
import '../../../../core/ui/widgets/list_loading_state.dart';
import '../../../projects/models/project_media.dart';
import '../../../projects/models/projects.dart';
import '../../../projects/repositories/project_media_repository.dart';
import '../../../projects/stores/projects_store.dart';

class ProjectsListWidgetDesktopVersion extends StatefulWidget {
  final ProjectsStore projectsStore;
  final int maxDiscoveredPage;
  final ValueChanged<int> onPageDiscovered;

  const ProjectsListWidgetDesktopVersion({
    super.key,
    required this.projectsStore,
    required this.maxDiscoveredPage,
    required this.onPageDiscovered,
  });

  @override
  State<ProjectsListWidgetDesktopVersion> createState() =>
      _ProjectsListWidgetDesktopVersionState();
}

class _ProjectsListWidgetDesktopVersionState
    extends State<ProjectsListWidgetDesktopVersion> {
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
      log('ProjectsListWidgetDesktop: erro ao carregar media', error: e, stackTrace: s);
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

        if (widget.projectsStore.showProgress) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: ListLoadingState(color: CustomColors.fresh_sprout),
          );
        } else if (widget.projectsStore.error != null &&
            widget.projectsStore.list.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: ListErrorState(
              message: 'Não foi possível carregar os projetos.',
              onRetry: () => widget.projectsStore.refreshData(),
              iconColor: CustomColors.copper_spice,
              messageColor: CustomColors.vanilla_haze,
            ),
          );
        } else if (widget.projectsStore.list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: ListEmptyState(
              message: 'Nenhum projeto encontrado.',
              messageColor: CustomColors.vanilla_haze,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGrid(),
            if (showPagination) ...[
              const SizedBox(height: 24),
              _buildPagination(),
            ],
          ],
        );
      },
    );
  }

  Widget _buildGrid() {
    final projects = widget.projectsStore.list;
    return FutureBuilder<Map<int, ProjectMedia>>(
      future: _mediaFuture,
      builder: (context, snapshot) {
        final mediaMap = snapshot.data ?? {};
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 310,
            ),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final item = projects[index];
              return ProjectTileDesktopVersion(
                project: item,
                projectMedia: item.id != null ? mediaMap[item.id] : null,
                onTap: () => _onProjectTap(item),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPagination() {
    final currentPage = widget.projectsStore.page;
    final isLastPage = widget.projectsStore.lastPage;
    final isLoading = widget.projectsStore.loading;

    final knownFromStore = isLastPage ? currentPage : currentPage + 1;
    final effectiveMaxPage = widget.maxDiscoveredPage > knownFromStore
        ? widget.maxDiscoveredPage
        : knownFromStore;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ArrowButton(
            icon: Icons.chevron_left_rounded,
            enabled: !isLoading && currentPage > 1,
            onTap: () => widget.projectsStore.goToPage(currentPage - 1),
            iconColor: Colors.white,
            disabledIconColor: CustomColors.concrete_mist,
            backgroundColor: Colors.white.withOpacity(0.1),
            iconSize: 18,
            borderRadius: 12,
            fixedSize: 36,
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
              iconColor: Colors.white,
              disabledIconColor: CustomColors.concrete_mist,
              backgroundColor: Colors.white.withOpacity(0.1),
              iconSize: 18,
              borderRadius: 12,
              fixedSize: 36,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              useRipple: false,
            ),
        ],
      ),
    );
  }

  void _onProjectTap(Projects project) {
    // TODO: navegar para a tela de detalhe do projeto.
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
            color: isActive
                ? CustomColors.fresh_sprout
                : Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? CustomColors.fresh_sprout
                  : Colors.white.withOpacity(0.3),
            ),
          ),
          child: Center(
            child: Text(
              '$page',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                color: enabled ? Colors.white : CustomColors.concrete_mist,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
