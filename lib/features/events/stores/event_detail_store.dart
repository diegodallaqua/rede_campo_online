import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../models/events_media.dart';
import '../repositories/event_media_repository.dart';

part 'event_detail_store.g.dart';

class EventDetailStore = EventDetailStoreBase with _$EventDetailStore;

abstract class EventDetailStoreBase with Store {
  final EventMediaRepository _mediaRepository = const EventMediaRepository();
  final int eventId;

  EventDetailStoreBase({required this.eventId}) {
    loadMedia();
  }

  @readonly
  ObservableList<EventMedia> _media = ObservableList<EventMedia>();

  @readonly
  bool _mediaLoading = false;

  @readonly
  String? _mediaError;

  @action
  Future<void> loadMedia() async {
    _mediaLoading = true;
    _mediaError = null;
    try {
      final items = await _mediaRepository.findByEventId(eventId);
      _media
        ..clear()
        ..addAll(items);
    } catch (e, s) {
      log(
        'EventDetailStore: Erro ao carregar mídia do evento $eventId',
        error: e,
        stackTrace: s,
      );
      _mediaError = e.toString();
    } finally {
      _mediaLoading = false;
    }
  }

  Future<void> refreshMedia() => loadMedia();
}
