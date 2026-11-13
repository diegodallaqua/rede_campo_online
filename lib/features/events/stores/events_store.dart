import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../core/stores/base_store.dart';
import '../../../core/stores/media_map_store.dart';
import '../models/events.dart';
import '../models/events_media.dart';
import '../repositories/event_media_repository.dart';
import '../repositories/events_repository.dart';

part 'events_store.g.dart';

class EventsStore = EventsStoreBase with _$EventsStore;

abstract class EventsStoreBase extends BaseStore<Events> with Store {
  final EventsRepository _repository = EventsRepository();

  EventsStoreBase({this.pageSize = 4}) {
    loadUpcoming();
    loadRecent();
    loadMedia();
  }

  final int pageSize;

  @readonly
  int _page = 1;

  @action
  void setPage(int value) => _page = value;

  @readonly
  bool _lastPage = false;

  @action
  void setLastPage(bool value) => _lastPage = value;

  @computed
  bool get showProgress => loading && list.isEmpty;

  void goToPage(int targetPage) {
    if (loading || targetPage == _page) return;
    setPage(targetPage);
    setLastPage(false);
    setData([]);
    loadUpcoming();
  }

  Future<void> loadUpcoming() async {
    final page = _page;
    setLoading(true);
    setError(null);
    try {
      final result = await _repository.findUpcomingEvents(
        page: page,
        take: pageSize,
      );
      if (_page != page) return;
      setData(result);
      if (result.length < pageSize) {
        setLastPage(true);
      } else {
        _peekNextPage(page);
      }
    } catch (e, s) {
      log(
        'EventsStore: Erro ao carregar próximos eventos (página $page)',
        error: e.toString(),
        stackTrace: s,
      );
      setError(e.toString());
    } finally {
      if (_page == page) setLoading(false);
    }
  }

  Future<void> _peekNextPage(int forPage) async {
    try {
      final peek = await _repository.findUpcomingEvents(
        page: forPage + 1,
        take: pageSize,
      );
      if (peek.isEmpty && _page == forPage) setLastPage(true);
    } catch (_) {}
  }

  @observable
  ObservableList<Events> recentList = ObservableList<Events>();

  @observable
  bool loadingRecent = false;

  @observable
  String? errorRecent;

  @action
  void _setLoadingRecent(bool value) => loadingRecent = value;

  @action
  void _setErrorRecent(String? value) => errorRecent = value;

  @action
  void _setRecentData(List<Events> items) {
    recentList.clear();
    recentList.addAll(items);
  }

  Future<void> loadRecent() async {
    _setLoadingRecent(true);
    _setErrorRecent(null);
    try {
      final result = await _repository.findRecentEvents(take: 4);
      _setRecentData(result);
    } catch (e, s) {
      log(
        'EventsStore: Erro ao carregar eventos recentes',
        error: e.toString(),
        stackTrace: s,
      );
      _setErrorRecent(e.toString());
    } finally {
      _setLoadingRecent(false);
    }
  }

  late final _media = MediaMapStore<EventMedia>(
    fetchAll: const EventMediaRepository().findAll,
    ownerId: (m) => m.event?.id,
    logLabel: 'EventsStore',
  );

  ObservableMap<int, EventMedia> get mediaMap => _media.map;

  Future<void> loadMedia() => _media.load();
}
