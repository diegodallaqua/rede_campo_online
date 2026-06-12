import 'package:mobx/mobx.dart';

import '../../../../core/stores/media_map_store.dart';
import '../../../../core/stores/paged_store.dart';
import '../../../events/models/events.dart';
import '../../../events/models/events_media.dart';
import '../../../events/repositories/event_media_repository.dart';
import '../../../events/repositories/events_repository.dart';

class AdminEventsStore extends PagedStore<Events> {
  final EventsRepository _repository = EventsRepository();

  AdminEventsStore({super.pageSize}) {
    loadMedia();
  }

  @override
  Future<List<Events>> fetchPage(int page) => _repository.findAllEvents(
        page: page,
        filterSearchStore: filterStore,
        take: pageSize,
      );

  @override
  Future<void> refreshData() async {
    await super.refreshData();
    loadMedia();
  }

  // Mídias dos eventos
  late final MediaMapStore<EventMedia> _media = MediaMapStore(
    fetchAll: EventMediaRepository().findAll,
    ownerId: (m) => m.event?.id,
    logLabel: 'AdminEventsStore',
  );

  ObservableMap<int, EventMedia> get mediaMap => _media.map;

  Future<void> loadMedia() => _media.load();
}
