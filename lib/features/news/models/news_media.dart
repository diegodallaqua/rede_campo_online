import 'news.dart';

class NewsMedia {
  NewsMedia({this.id, this.news, this.name, this.media});

  int? id;
  News? news;
  String? name;
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
