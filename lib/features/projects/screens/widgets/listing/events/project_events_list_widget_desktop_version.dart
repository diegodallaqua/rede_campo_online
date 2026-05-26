import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../../../core/ui/listing_tiles/events/event_tile_desktop_version.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/arrow_button.dart';
import '../../../../../../core/ui/widgets/list_empty_state.dart';
import '../../../../../../core/ui/widgets/list_error_state.dart';
import '../../../../../../core/ui/widgets/list_loading_state.dart';
import '../../../../../events/models/events.dart';
import '../../../../../events/models/events_media.dart';
import '../../../../stores/project_detail_store.dart';

class ProjectEventsListWidgetDesktopVersion extends StatefulWidget {
  final ProjectDetailStore projectDetailStore;

  static const double _cardWidth = 220.0;
  static const double _cardHeight = 300.0;
  static const double _gap = 16.0;

  const ProjectEventsListWidgetDesktopVersion({
    super.key,
    required this.projectDetailStore,
  });

  @override
  State<ProjectEventsListWidgetDesktopVersion> createState() =>
      _ProjectEventsListWidgetDesktopVersionState();
}

class _ProjectEventsListWidgetDesktopVersionState
    extends State<ProjectEventsListWidgetDesktopVersion> {
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
            ProjectEventsListWidgetDesktopVersion._cardWidth -
            ProjectEventsListWidgetDesktopVersion._gap)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    final target = (_scrollController.offset +
            ProjectEventsListWidgetDesktopVersion._cardWidth +
            ProjectEventsListWidgetDesktopVersion._gap)
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
        if (widget.projectDetailStore.eventsLoading) {
          return const ListLoadingState(color: CustomColors.fresh_sprout);
        }
        if (widget.projectDetailStore.eventsError != null) {
          return ListErrorState(
            message: 'Não foi possível carregar os eventos.',
            onRetry: () {
              widget.projectDetailStore.refreshEvents();
            },
            iconColor: CustomColors.copper_spice,
            messageColor: CustomColors.pine_shadow,
          );
        }
        final events = widget.projectDetailStore.events.toList();
        if (events.isEmpty) {
          return const ListEmptyState(
            message: 'Nenhum evento cadastrado para este projeto.',
            messageColor: CustomColors.vanilla_haze,
          );
        }
        return _buildList(events, widget.projectDetailStore.eventMediaMap);
      },
    );
  }

  Widget _buildList(List<Events> events, Map<int, EventMedia> mediaMap) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth - 2 * 40 - 2 * 8;
        final int visibleCount =
            ((availableWidth + ProjectEventsListWidgetDesktopVersion._gap) /
                    (ProjectEventsListWidgetDesktopVersion._cardWidth +
                        ProjectEventsListWidgetDesktopVersion._gap))
                .floor()
                .clamp(1, events.length);
        final bool allFit = events.length <= visibleCount;

        return Row(
          children: [
            ArrowButton(
              icon: Icons.chevron_left_rounded,
              enabled: !allFit && _canScrollLeft,
              onTap: _scrollLeft,
              iconColor: CustomColors.midnight_slate,
              disabledIconColor: CustomColors.concrete_mist,
              backgroundColor: CustomColors.midnight_slate.withOpacity(0.08),
              iconSize: 20,
              borderRadius: 12,
              fixedSize: 40,
              useRipple: false,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: ProjectEventsListWidgetDesktopVersion._cardHeight,
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const SizedBox(
                    width: ProjectEventsListWidgetDesktopVersion._gap,
                  ),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return SizedBox(
                      width: ProjectEventsListWidgetDesktopVersion._cardWidth,
                      child: EventTileDesktopVersion(
                        event: event,
                        eventMedia:
                            event.id != null ? mediaMap[event.id] : null,
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
              iconColor: CustomColors.midnight_slate,
              disabledIconColor: CustomColors.concrete_mist,
              backgroundColor: CustomColors.midnight_slate.withOpacity(0.08),
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
