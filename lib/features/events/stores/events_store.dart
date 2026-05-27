import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../core/utils/stores/base_store.dart';
import '../models/events.dart';
import '../models/events_media.dart';
import '../repositories/event_media_repository.dart';
import '../repositories/events_repository.dart';

part 'events_store.g.dart';

class EventsStore = EventsStoreBase with _$EventsStore;

abstract class EventsStoreBase extends BaseStore<Events> with Store {
  final EventsRepository _repository = EventsRepository();
  final EventMediaRepository _mediaRepository = EventMediaRepository();

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

  void resetUpcoming() {
    setPage(1);
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

  @observable
  ObservableMap<int, EventMedia> mediaMap = ObservableMap<int, EventMedia>();

  @observable
  bool loadingMedia = false;

  @observable
  String? errorMedia;

  @action
  void _setLoadingMedia(bool value) => loadingMedia = value;

  @action
  void _setErrorMedia(String? value) => errorMedia = value;

  @action
  void _setMediaData(Map<int, EventMedia> data) {
    mediaMap.clear();
    mediaMap.addAll(data);
  }

  Future<void> loadMedia() async {
    _setLoadingMedia(true);
    _setErrorMedia(null);
    try {
      final mediaList = await _mediaRepository.findAll();
      final map = <int, EventMedia>{};
      for (final m in mediaList) {
        final eventId = m.event?.id;
        if (eventId != null && !map.containsKey(eventId)) {
          map[eventId] = m;
        }
      }
      _setMediaData(map);
    } catch (e, s) {
      log(
        'EventsStore: Erro ao carregar mídias dos eventos',
        error: e.toString(),
        stackTrace: s,
      );
      _setErrorMedia(e.toString());
    } finally {
      _setLoadingMedia(false);
    }
  }
}
