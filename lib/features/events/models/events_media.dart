import 'events.dart';

class EventMedia {
  EventMedia({
    this.id,
    this.event,
    this.name,
    this.media
  });

  int? id;
  Events? event;
  String? name;
  String? media;

  @override
  String toString() {
    return 'EventMedia{id: $id, event: $event, name: $name, media:$media}';
  }

  factory EventMedia.fromMap(Map<String, dynamic> map) {
    return EventMedia(
      id: map['id'],
      event: map.containsKey('event') && map['event'] != null ? Events.fromMap(map['event'] ?? {}) : null,
      name: (map['name'] ?? '') as String,
      media: (map['media'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'news_id': event!.id,
    'name': name!,
    'media': media!,
  };
}

