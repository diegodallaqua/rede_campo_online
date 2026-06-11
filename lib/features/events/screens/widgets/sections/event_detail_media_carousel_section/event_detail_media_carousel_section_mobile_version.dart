import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/dialogs/image_viewer_dialog.dart';
import '../../../../../../core/ui/widgets/list_error_state.dart';
import '../../../../../../core/ui/widgets/list_loading_state.dart';
import '../../../../../../core/utils/placeholders.dart';
import '../../../../stores/event_detail_store.dart';

class EventDetailMediaCarouselSectionMobileVersion extends StatefulWidget {
  final EventDetailStore eventDetailStore;

  const EventDetailMediaCarouselSectionMobileVersion({
    super.key,
    required this.eventDetailStore,
  });

  @override
  State<EventDetailMediaCarouselSectionMobileVersion> createState() =>
      _EventDetailMediaCarouselSectionMobileVersionState();
}

class _EventDetailMediaCarouselSectionMobileVersionState
    extends State<EventDetailMediaCarouselSectionMobileVersion> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (widget.eventDetailStore.mediaLoading) {
          return const SizedBox(
            height: 240,
            child: ListLoadingState(color: CustomColors.copper_spice),
          );
        }

        if (widget.eventDetailStore.mediaError != null) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: ListErrorState(
              message: 'Não foi possível carregar as imagens.',
              onRetry: widget.eventDetailStore.refreshMedia,
              iconColor: CustomColors.copper_spice,
              messageColor: CustomColors.pine_shadow,
            ),
          );
        }

        final media = widget.eventDetailStore.media.toList();
        if (media.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              SizedBox(
                height: 240,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: media.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, index) {
                    final item = media[index];
                    final hasImage = item.media?.isNotEmpty == true;

                    final viewable = media
                        .where((m) => m.media?.isNotEmpty == true)
                        .toList();
                    final viewableIndex =
                        viewable.indexWhere((m) => m.id == item.id);

                    final image = Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: hasImage
                            ? Image.network(
                                item.media!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const ImagePlaceholder(),
                              )
                            : const ImagePlaceholder(),
                      ),
                    );

                    if (!hasImage || viewableIndex < 0) return image;

                    return GestureDetector(
                      onTap: () => ImageViewerDialog.show(
                        context: context,
                        imageUrls: viewable.map((m) => m.media!).toList(),
                        imageNames: viewable.map((m) => m.name).toList(),
                        initialIndex: viewableIndex,
                      ),
                      child: image,
                    );
                  },
                ),
              ),
              if (media.length > 1) ...[
                const SizedBox(height: 12),
                _DotIndicator(
                  count: media.length,
                  current: _currentPage,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int count;
  final int current;

  const _DotIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == current ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: i == current
                ? CustomColors.copper_spice
                : CustomColors.concrete_mist,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
