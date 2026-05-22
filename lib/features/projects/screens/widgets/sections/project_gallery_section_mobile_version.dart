import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../core/ui/widgets/image_viewer_dialog.dart';
import '../../../../../core/ui/widgets/list_empty_state.dart';
import '../../../../../core/ui/widgets/list_error_state.dart';
import '../../../../../core/ui/widgets/list_loading_state.dart';
import '../../../../../core/utils/placeholders.dart';
import '../../../models/project_media.dart';
import '../../../stores/project_detail_store.dart';

class ProjectGallerySectionMobileVersion extends StatelessWidget {
  final ProjectDetailStore projectDetailStore;

  const ProjectGallerySectionMobileVersion({
    super.key,
    required this.projectDetailStore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 24, 12, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Galeria do Projeto',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.copper_spice,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Observer(
            builder: (context) {
              if (projectDetailStore.mediaLoading) {
                return const ListLoadingState(color: CustomColors.copper_spice);
              }
              if (projectDetailStore.mediaError != null) {
                return ListErrorState(
                  message: 'Não foi possível carregar a galeria.',
                  onRetry: () {
                    projectDetailStore.refreshMedia();
                  },
                  iconColor: CustomColors.copper_spice,
                  messageColor: CustomColors.pine_shadow,
                );
              }
              final media = projectDetailStore.projectMedia.toList();
              if (media.isEmpty) {
                return const ListEmptyState(
                  message: 'Nenhuma imagem disponível para este projeto.',
                );
              }
              return _buildRows(context, media);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRows(BuildContext context, List<ProjectMedia> media) {
    const double gap = 10.0;
    final rows = <Widget>[];

    for (int i = 0; i < media.length; i += 2) {
      if (i > 0) rows.add(const SizedBox(height: gap));

      if (i + 1 < media.length) {
        rows.add(Row(
          children: [
            Expanded(child: _buildItem(context, media[i], media)),
            const SizedBox(width: gap),
            Expanded(child: _buildItem(context, media[i + 1], media)),
          ],
        ));
      } else {
        rows.add(
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - gap) / 2;
              return Center(
                child: SizedBox(
                  width: itemWidth,
                  child: _buildItem(context, media[i], media),
                ),
              );
            },
          ),
        );
      }
    }

    return Column(children: rows);
  }

  Widget _buildItem(
      BuildContext context, ProjectMedia item, List<ProjectMedia> allMedia) {
    final hasImage = item.media?.isNotEmpty == true;

    final image = AspectRatio(
      aspectRatio: 1.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: hasImage
            ? Image.network(
                item.media!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ImagePlaceholder(),
              )
            : const ImagePlaceholder(),
      ),
    );

    if (!hasImage) return image;

    final viewable =
        allMedia.where((m) => m.media?.isNotEmpty == true).toList();
    final index = viewable.indexWhere((m) => m.id == item.id);

    return GestureDetector(
      onTap: index < 0
          ? null
          : () => ImageViewerDialog.show(
                context: context,
                imageUrls: viewable.map((m) => m.media!).toList(),
                imageNames: viewable.map((m) => m.name).toList(),
                initialIndex: index,
              ),
      child: image,
    );
  }
}
