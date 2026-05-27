import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../events/models/events.dart';
import '../../events/models/events_media.dart';
import '../../events/repositories/event_media_repository.dart';
import '../../events/repositories/events_repository.dart';
import '../models/project_media.dart';
import '../repositories/project_media_repository.dart';

part 'project_detail_store.g.dart';

class ProjectDetailStore = ProjectDetailStoreBase with _$ProjectDetailStore;

abstract class ProjectDetailStoreBase with Store {
  final ProjectMediaRepository _mediaRepository = ProjectMediaRepository();
  final EventsRepository _eventsRepository = EventsRepository();
  final EventMediaRepository _eventMediaRepository = EventMediaRepository();

  final int projectId;

  ProjectDetailStoreBase({required this.projectId}) {
    loadData();
  }

  @readonly
  ObservableList<ProjectMedia> _projectMedia = ObservableList<ProjectMedia>();

  @readonly
  bool _mediaLoading = false;

  @readonly
  String? _mediaError;

  @computed
  ProjectMedia? get coverMedia =>
      _projectMedia.isNotEmpty ? _projectMedia.first : null;

  @readonly
  ObservableList<Events> _events = ObservableList<Events>();

  @readonly
  ObservableMap<int, EventMedia> _eventMediaMap =
      ObservableMap<int, EventMedia>();

  @readonly
  bool _eventsLoading = false;

  @readonly
  String? _eventsError;

  Future<void> loadData() => Future.wait([loadMedia(), loadEvents()]);

  @action
  Future<void> loadMedia() async {
    _mediaLoading = true;
    _mediaError = null;
    try {
      final all = await _mediaRepository.findAll();
      _projectMedia
        ..clear()
        ..addAll(all.where((m) => m.project?.id == projectId));
    } catch (e, s) {
      log(
        'ProjectDetailStore: Erro ao carregar mídia do projeto $projectId',
        error: e,
        stackTrace: s,
      );
      _mediaError = e.toString();
    } finally {
      _mediaLoading = false;
    }
  }

  @action
  Future<void> loadEvents() async {
    _eventsLoading = true;
    _eventsError = null;
    try {
      final results = await Future.wait([
        _eventsRepository.findByProjectId(projectId),
        _eventMediaRepository.findAll(),
      ]);
      final events = results[0] as List<Events>;
      final allMedia = results[1] as List<EventMedia>;

      _events
        ..clear()
        ..addAll(events);

      _eventMediaMap.clear();
      for (final m in allMedia) {
        final eventId = m.event?.id;
        if (eventId != null && !_eventMediaMap.containsKey(eventId)) {
          _eventMediaMap[eventId] = m;
        }
      }
    } catch (e, s) {
      log(
        'ProjectDetailStore: Erro ao carregar eventos do projeto $projectId',
        error: e,
        stackTrace: s,
      );
      _eventsError = e.toString();
    } finally {
      _eventsLoading = false;
    }
  }

  Future<void> refreshMedia() => loadMedia();

  Future<void> refreshEvents() => loadEvents();
}
