import '../../../core/models/media_attachment.dart';
import 'news.dart';

class NewsMedia implements MediaAttachment {
  NewsMedia({this.id, this.news, this.name, this.media});

  @override
  int? id;
  News? news;
  @override
  String? name;
  @override
  String? media;

  @override
  String toString() {
    return 'NewsMedia{id: $id, news: $news, name: $name, media:$media}';
  }

  factory NewsMedia.fromMap(Map<String, dynamic> map) {
    return NewsMedia(
      id: map['id'],
      news: map.containsKey('news') && map['news'] != null
          ? News.fromMap(map['news'] ?? {})
          : null,
      name: (map['name'] ?? '') as String,
      media: (map['media'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'news_id': news!.id,
        'name': name!,
        'media': media!,
      };
}
