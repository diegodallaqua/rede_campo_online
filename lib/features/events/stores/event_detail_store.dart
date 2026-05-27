import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../models/events_media.dart';
import '../repositories/event_media_repository.dart';

part 'event_detail_store.g.dart';

class EventDetailStore = EventDetailStoreBase with _$EventDetailStore;

abstract class EventDetailStoreBase with Store {
  final EventMediaRepository _mediaRepository = EventMediaRepository();
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
      final all = await _mediaRepository.findAll();
      _media
        ..clear()
        ..addAll(all.where((m) => m.event?.id == eventId));
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
