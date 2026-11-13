import '../../../core/global/constants/api_constants.dart';
import '../../../core/repositories/media_repository.dart';
import '../models/events_media.dart';

class EventMediaRepository extends MediaRepository<EventMedia> {
  const EventMediaRepository();

  @override
  String get path => eventMediaURL;

  @override
  String get ofOne => 'do evento';

  @override
  String get ofMany => 'dos eventos';

  @override
  EventMedia fromMap(Map<String, dynamic> map) => EventMedia.fromMap(map);

  @override
  Map<String, dynamic> toMap(EventMedia media) => media.toMap();

  @override
  int? ownerIdOf(EventMedia media) => media.event?.id;

  Future<List<EventMedia>> findByEventId(int id) => findByOwnerId(id);
}
