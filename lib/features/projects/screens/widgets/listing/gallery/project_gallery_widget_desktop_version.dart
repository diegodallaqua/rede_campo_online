import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/arrow_button.dart';
import '../../../../../../core/ui/widgets/list_empty_state.dart';
import '../../../../../../core/ui/widgets/list_error_state.dart';
import '../../../../../../core/ui/widgets/list_loading_state.dart';
import '../../../../../../core/utils/placeholders.dart';
import '../../../../models/project_media.dart';
import '../../../../stores/project_detail_store.dart';

class ProjectGalleryWidgetDesktopVersion extends StatefulWidget {
  final ProjectDetailStore projectDetailStore;

  static const int _perPage = 6;

  const ProjectGalleryWidgetDesktopVersion({
    super.key,
    required this.projectDetailStore,
  });

  @override
  State<ProjectGalleryWidgetDesktopVersion> createState() =>
      _ProjectGalleryWidgetDesktopVersionState();
}

class _ProjectGalleryWidgetDesktopVersionState
    extends State<ProjectGalleryWidgetDesktopVersion> {
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (widget.projectDetailStore.mediaLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: ListLoadingState(color: CustomColors.fresh_sprout),
          );
        }
        if (widget.projectDetailStore.mediaError != null) {
          return ListErrorState(
            message: 'Não foi possível carregar a galeria.',
            onRetry: () {
              widget.projectDetailStore.refreshMedia();
            },
            iconColor: CustomColors.copper_spice,
            messageColor: CustomColors.vanilla_haze,
          );
        }
        final media = widget.projectDetailStore.projectMedia.toList();
        if (media.isEmpty) {
          return const ListEmptyState(
            message: 'Nenhuma imagem disponível para este projeto.',
            messageColor: CustomColors.vanilla_haze,
          );
        }
        return _buildPaginatedGallery(media);
      },
    );
  }

  Widget _buildPaginatedGallery(List<ProjectMedia> media) {
    final totalPages =
        (media.length / ProjectGalleryWidgetDesktopVersion._perPage).ceil();
    final safePage = _currentPage.clamp(1, totalPages);
    final start = (safePage - 1) * ProjectGalleryWidgetDesktopVersion._perPage;
    final end = (start + ProjectGalleryWidgetDesktopVersion._perPage)
        .clamp(0, media.length);
    final pageMedia = media.sublist(start, end);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildGrid(pageMedia),
        if (totalPages > 1) ...[
          const SizedBox(height: 24),
          _buildPagination(totalPages, safePage),
        ],
      ],
    );
  }

  Widget _buildGrid(List<ProjectMedia> pageMedia) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 4 / 3,
      ),
      itemCount: pageMedia.length,
      itemBuilder: (context, index) {
        final item = pageMedia[index];
        final hasImage = item.media?.isNotEmpty == true;
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: hasImage
              ? Image.network(
                  item.media!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ImagePlaceholder(),
                )
              : const ImagePlaceholder(),
        );
      },
    );
  }

  Widget _buildPagination(int totalPages, int currentPage) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ArrowButton(
            icon: Icons.chevron_left_rounded,
            enabled: currentPage > 1,
            onTap: () => setState(() => _currentPage = currentPage - 1),
            iconColor: CustomColors.vanilla_haze,
            disabledIconColor: CustomColors.concrete_mist,
            backgroundColor: Colors.white.withOpacity(0.1),
            iconSize: 18,
            borderRadius: 12,
            fixedSize: 36,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            useRipple: false,
          ),
          ...List.generate(totalPages, (index) {
            final page = index + 1;
            return _GalleryPageButton(
              page: page,
              isActive: page == currentPage,
              onTap: () => setState(() => _currentPage = page),
            );
          }),
          ArrowButton(
            icon: Icons.chevron_right_rounded,
            enabled: currentPage < totalPages,
            onTap: () => setState(() => _currentPage = currentPage + 1),
            iconColor: CustomColors.vanilla_haze,
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
}

class _GalleryPageButton extends StatelessWidget {
  final int page;
  final bool isActive;
  final VoidCallback onTap;

  const _GalleryPageButton({
    required this.page,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: isActive ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive
                ? CustomColors.fresh_sprout
                : CustomColors.vanilla_haze.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? CustomColors.fresh_sprout
                  : CustomColors.vanilla_haze.withOpacity(0.3),
            ),
          ),
          child: Center(
            child: Text(
              '$page',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                color: CustomColors.vanilla_haze,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
