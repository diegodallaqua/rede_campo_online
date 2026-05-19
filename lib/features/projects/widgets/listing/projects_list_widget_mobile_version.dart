import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/projects/project_tile_mobile_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/arrow_button.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';
import 'package:rede_campo_online/features/projects/models/projects.dart';
import 'package:rede_campo_online/features/projects/stores/projects_store.dart';

class ProjectsListWidgetMobileVersion extends StatelessWidget {
  final ProjectsStore projectsStore;
  final int maxDiscoveredPage;
  final ValueChanged<int> onPageDiscovered;

  const ProjectsListWidgetMobileVersion({
    super.key,
    required this.projectsStore,
    required this.maxDiscoveredPage,
    required this.onPageDiscovered,
  });

  void _notifyPageDiscovered(int discovered) {
    if (discovered > maxDiscoveredPage) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        onPageDiscovered(discovered);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (!projectsStore.loading && projectsStore.list.isNotEmpty) {
          final discovered =
              projectsStore.page + (projectsStore.lastPage ? 0 : 1);
          _notifyPageDiscovered(discovered);
        }

        // Mostra o carousel se: há mais páginas (!lastPage), já navegamos para
        // além da página 1, ou já descobrimos múltiplas páginas anteriormente.
        final showPagination = projectsStore.list.isNotEmpty &&
            (!projectsStore.lastPage ||
                projectsStore.page > 1 ||
                maxDiscoveredPage > 1);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (projectsStore.showProgress)
              const ListLoadingState()
            else if (projectsStore.error != null && projectsStore.list.isEmpty)
              ListErrorState(
                message: 'Não foi possível carregar os projetos.',
                onRetry: projectsStore.refreshData,
                iconColor: CustomColors.copper_spice,
                messageColor: CustomColors.vanilla_haze,
              )
            else if (projectsStore.list.isEmpty)
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
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: projectsStore.list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final project = projectsStore.list[index];
        return ProjectTileMobileVersion(
          project: project,
          onTap: () => _onProjectTap(project),
        );
      },
    );
  }

  void _onProjectTap(Projects project) {
    // TODO: navegar para a tela de detalhe do projeto
  }

  Widget _buildPageCarousel() {
    final currentPage = projectsStore.page;
    final isLastPage = projectsStore.lastPage;
    final isLoading = projectsStore.loading;

    // Garante que sempre exibimos pelo menos até a próxima página conhecida
    // (currentPage+1 quando não é última), independente do maxDiscoveredPage.
    final knownFromStore = isLastPage ? currentPage : currentPage + 1;
    final effectiveMaxPage =
        maxDiscoveredPage > knownFromStore ? maxDiscoveredPage : knownFromStore;

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ArrowButton(
              icon: Icons.chevron_left_rounded,
              enabled: !isLoading && currentPage > 1,
              onTap: () => projectsStore.goToPage(currentPage - 1),
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
                onTap: () => projectsStore.goToPage(page),
              );
            }),
            if (!isLastPage)
              ArrowButton(
                icon: Icons.chevron_right_rounded,
                enabled: !isLoading,
                onTap: () => projectsStore.goToPage(currentPage + 1),
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
