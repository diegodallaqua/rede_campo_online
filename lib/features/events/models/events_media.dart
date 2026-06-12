import '../../../core/models/media_attachment.dart';
import 'events.dart';

class EventMedia implements MediaAttachment {
  EventMedia({this.id, this.event, this.name, this.media});

  @override
  int? id;
  Events? event;
  @override
  String? name;
  @override
  String? media;

  @override
  String toString() {
    return 'EventMedia{id: $id, event: $event, name: $name, media:$media}';
  }

  factory EventMedia.fromMap(Map<String, dynamic> map) {
    return EventMedia(
      id: map['id'],
      event: map.containsKey('event') && map['event'] != null
          ? Events.fromMap(map['event'] ?? {})
          : null,
      name: (map['name'] ?? '') as String,
      media: (map['media'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'event_id': event!.id,
        'name': name!,
        'media': media!,
      };
}
