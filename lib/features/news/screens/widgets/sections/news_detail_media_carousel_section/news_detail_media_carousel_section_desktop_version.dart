import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/image_viewer_dialog.dart';
import '../../../../../../core/ui/widgets/list_error_state.dart';
import '../../../../../../core/ui/widgets/list_loading_state.dart';
import '../../../../../../core/utils/placeholders.dart';
import '../../../../stores/news_detail_store.dart';

class NewsDetailMediaCarouselSectionDesktopVersion extends StatelessWidget {
  final NewsDetailStore newsDetailStore;

  const NewsDetailMediaCarouselSectionDesktopVersion({
    super.key,
    required this.newsDetailStore,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (newsDetailStore.mediaLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: ListLoadingState(color: CustomColors.fresh_sprout),
          );
        }

        if (newsDetailStore.mediaError != null) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(48, 56, 48, 32),
                child: ListErrorState(
                  message: 'Não foi possível carregar as imagens.',
                  onRetry: newsDetailStore.refreshMedia,
                  iconColor: CustomColors.copper_spice,
                  messageColor: CustomColors.vanilla_haze,
                ),
              ),
            ),
          );
        }

        final viewable = newsDetailStore.media
            .where((m) => m.media?.isNotEmpty == true)
            .toList();

        if (viewable.isEmpty) return const SizedBox.shrink();

        final urls = viewable.map((m) => m.media!).toList();
        final names = viewable.map((m) => m.name).toList();

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(48, 56, 48, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SectionHeader(label: 'Galeria'),
                  const SizedBox(height: 32),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 4 / 3,
                    ),
                    itemCount: viewable.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => ImageViewerDialog.show(
                          context: context,
                          imageUrls: urls,
                          imageNames: names,
                          initialIndex: index,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            viewable[index].media!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const ImagePlaceholder(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: CustomColors.fresh_sprout,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CustomColors.fresh_sprout.withOpacity(0.4),
                  CustomColors.fresh_sprout.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
