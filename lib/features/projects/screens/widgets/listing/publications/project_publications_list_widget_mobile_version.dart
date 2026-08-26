import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../../core/ui/listing_tiles/publications/publication_tile_mobile_version.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/list_empty_state.dart';
import '../../../../../../core/ui/widgets/list_error_state.dart';
import '../../../../../../core/ui/widgets/list_loading_state.dart';
import '../../../../../../core/utils/publication_navigation.dart';
import '../../../../../publications/models/publications.dart';
import '../../../../stores/project_detail_store.dart';

class ProjectPublicationsListWidgetMobileVersion extends StatefulWidget {
  final ProjectDetailStore projectDetailStore;

  /// Quantidade de itens visíveis antes de a lista rolar internamente.
  final int visibleCount;

  static const double _tileHeight = 145.0;
  static const double _separatorHeight = 8.0;

  const ProjectPublicationsListWidgetMobileVersion({
    super.key,
    required this.projectDetailStore,
    this.visibleCount = 3,
  });

  @override
  State<ProjectPublicationsListWidgetMobileVersion> createState() =>
      _ProjectPublicationsListWidgetMobileVersionState();
}

class _ProjectPublicationsListWidgetMobileVersionState
    extends State<ProjectPublicationsListWidgetMobileVersion> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Calcula a altura visível para [n] itens, incluindo seus separadores.
  double _heightForItems(int n) {
    if (n <= 0) return 0;
    return (n * ProjectPublicationsListWidgetMobileVersion._tileHeight) +
        ((n - 1) * ProjectPublicationsListWidgetMobileVersion._separatorHeight);
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
    final double maxHeight = _heightForItems(widget.visibleCount);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Scrollbar(
        thumbVisibility: true,
        controller: _scrollController,
        child: ListView.separated(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: publications.length,
          separatorBuilder: (_, __) => const SizedBox(
            height: ProjectPublicationsListWidgetMobileVersion._separatorHeight,
          ),
          itemBuilder: (context, index) {
            return PublicationTileMobileVersion(
              publication: publications[index],
              onTap: () => openPublicationDetails(context, publications[index]),
              margin: const EdgeInsets.symmetric(horizontal: 2),
            );
          },
        ),
      ),
    );
  }
}
