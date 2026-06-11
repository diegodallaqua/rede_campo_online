import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/events/event_tile_mobile_version.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/list_empty_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_error_state.dart';
import 'package:rede_campo_online/core/ui/widgets/list_loading_state.dart';
import 'package:rede_campo_online/features/admin/events/stores/admin_events_store.dart';
import 'package:rede_campo_online/features/events/models/events.dart';

class AdminEventsListWidgetMobileVersion extends StatefulWidget {
  final AdminEventsStore adminEventsStore;
  final Future<void> Function(Events? event) onTapEvent;

  const AdminEventsListWidgetMobileVersion({
    super.key,
    required this.adminEventsStore,
    required this.onTapEvent,
  });

  @override
  State<AdminEventsListWidgetMobileVersion> createState() =>
      _AdminEventsListWidgetMobileVersionState();
}

class _AdminEventsListWidgetMobileVersionState
    extends State<AdminEventsListWidgetMobileVersion> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final adminEventsStore = widget.adminEventsStore;
    if (adminEventsStore.loading || adminEventsStore.lastPage) return;

    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      adminEventsStore.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final adminEventsStore = widget.adminEventsStore;

        if (adminEventsStore.showProgress) {
          return const Center(child: ListLoadingState());
        } else if (adminEventsStore.error != null &&
            adminEventsStore.list.isEmpty) {
          return Center(
            child: ListErrorState(
              message: adminEventsStore.error ??
                  'Não foi possível carregar os eventos.',
              onRetry: adminEventsStore.refreshData,
            ),
          );
        } else if (adminEventsStore.list.isEmpty) {
          return const Center(
            child: ListEmptyState(
              message: 'Nenhum evento cadastrado.',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: adminEventsStore.refreshData,
          color: CustomColors.copper_spice,
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 215,
            ),
            itemCount: adminEventsStore.itemCount,
            itemBuilder: (context, index) {
              if (index >= adminEventsStore.list.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: CustomColors.copper_spice,
                      ),
                    ),
                  ),
                );
              }

              final event = adminEventsStore.list[index];
              return EventTileMobileVersion(
                event: event,
                eventMedia: adminEventsStore.mediaMap[event.id],
                onTap: () => widget.onTapEvent(event),
                pinInfoToBottom: true,
              );
            },
          ),
        );
      },
    );
  }
}
