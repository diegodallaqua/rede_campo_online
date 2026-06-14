import 'package:mobx/mobx.dart';

import '../../../../core/stores/media_map_store.dart';
import '../../../../core/stores/paged_store.dart';
import '../../../events/models/events.dart';
import '../../../events/models/events_media.dart';
import '../../../events/repositories/event_media_repository.dart';
import '../../../events/repositories/events_repository.dart';

part 'admin_events_store.g.dart';

class AdminEventsStore = AdminEventsStoreBase with _$AdminEventsStore;

abstract class AdminEventsStoreBase extends PagedStore<Events> with Store {
  final EventsRepository _repository = EventsRepository();

  AdminEventsStoreBase({super.pageSize}) {
    loadMedia();
  }

  // Estado de carregamento/erro da listagem, exposto como observável próprio
  // do store (espelha o estado herdado de BaseStore via setLoading/setError).
  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @override
  @action
  void setLoading(bool value) {
    super.setLoading(value);
    isLoading = value;
  }

  @override
  @action
  void setError(String? message) {
    super.setError(message);
    errorMessage = message;
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
