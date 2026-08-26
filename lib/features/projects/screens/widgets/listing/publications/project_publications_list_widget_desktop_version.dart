import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../../core/ui/listing_tiles/publications/publication_tile_desktop_version.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/arrow_button.dart';
import '../../../../../../core/ui/widgets/list_empty_state.dart';
import '../../../../../../core/ui/widgets/list_error_state.dart';
import '../../../../../../core/ui/widgets/list_loading_state.dart';
import '../../../../../../core/utils/publication_navigation.dart';
import '../../../../../publications/models/publications.dart';
import '../../../../stores/project_detail_store.dart';

class ProjectPublicationsListWidgetDesktopVersion extends StatefulWidget {
  final ProjectDetailStore projectDetailStore;

  static const double _cardWidth = 300.0;
  static const double _cardHeight = 240.0;
  static const double _gap = 16.0;

  const ProjectPublicationsListWidgetDesktopVersion({
    super.key,
    required this.projectDetailStore,
  });

  @override
  State<ProjectPublicationsListWidgetDesktopVersion> createState() =>
      _ProjectPublicationsListWidgetDesktopVersionState();
}

class _ProjectPublicationsListWidgetDesktopVersionState
    extends State<ProjectPublicationsListWidgetDesktopVersion> {
  final ScrollController _scrollController = ScrollController();
  bool _canScrollLeft = false;
  bool _canScrollRight = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateArrowState);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateArrowState);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateArrowState() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    setState(() {
      _canScrollLeft = pos.pixels > 0;
      _canScrollRight = pos.pixels < pos.maxScrollExtent;
    });
  }

  void _scrollLeft() {
    final target = (_scrollController.offset -
            ProjectPublicationsListWidgetDesktopVersion._cardWidth -
            ProjectPublicationsListWidgetDesktopVersion._gap)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    final target = (_scrollController.offset +
            ProjectPublicationsListWidgetDesktopVersion._cardWidth +
            ProjectPublicationsListWidgetDesktopVersion._gap)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (widget.projectDetailStore.publicationsLoading) {
          return const ListLoadingState(color: CustomColors.copper_spice);
        }
        if (widget.projectDetailStore.publicationsError != null) {
          return ListErrorState(
            message: 'Não foi possível carregar as publicações.',
            onRetry: () {
              widget.projectDetailStore.refreshPublications();
            },
            iconColor: CustomColors.copper_spice,
            messageColor: CustomColors.vanilla_haze,
          );
        }
        final publications = widget.projectDetailStore.publications.toList();
        if (publications.isEmpty) {
          return const ListEmptyState(
            message: 'Nenhuma publicação vinculada a este projeto.',
            messageColor: CustomColors.vanilla_haze,
          );
        }
        return _buildList(publications);
      },
    );
  }

  Widget _buildList(List<Publications> publications) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth - 2 * 40 - 2 * 8;
        final int visibleCount = ((availableWidth +
                    ProjectPublicationsListWidgetDesktopVersion._gap) /
                (ProjectPublicationsListWidgetDesktopVersion._cardWidth +
                    ProjectPublicationsListWidgetDesktopVersion._gap))
            .floor()
            .clamp(1, publications.length);
        final bool allFit = publications.length <= visibleCount;

        return Row(
          children: [
            ArrowButton(
              icon: Icons.chevron_left_rounded,
              enabled: !allFit && _canScrollLeft,
              onTap: _scrollLeft,
              iconColor: CustomColors.concrete_mist,
              disabledIconColor: CustomColors.concrete_mist,
              backgroundColor: CustomColors.concrete_mist.withOpacity(0.08),
              iconSize: 20,
              borderRadius: 12,
              fixedSize: 40,
              useRipple: false,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: ProjectPublicationsListWidgetDesktopVersion._cardHeight,
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: publications.length,
                  separatorBuilder: (_, __) => const SizedBox(
                    width: ProjectPublicationsListWidgetDesktopVersion._gap,
                  ),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: ProjectPublicationsListWidgetDesktopVersion
                          ._cardWidth,
                      child: PublicationTileDesktopVersion(
                        publication: publications[index],
                        onTap: () => openPublicationDetails(
                          context,
                          publications[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            ArrowButton(
              icon: Icons.chevron_right_rounded,
              enabled: !allFit && _canScrollRight,
              onTap: _scrollRight,
              iconColor: CustomColors.concrete_mist,
              disabledIconColor: CustomColors.concrete_mist,
              backgroundColor: CustomColors.concrete_mist.withOpacity(0.08),
              iconSize: 20,
              borderRadius: 12,
              fixedSize: 40,
              useRipple: false,
            ),
          ],
        );
      },
    );
  }
}
