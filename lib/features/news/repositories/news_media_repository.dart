import '../../../core/global/constants/api_constants.dart';
import '../../../core/repositories/media_repository.dart';
import '../models/news_media.dart';

class NewsMediaRepository extends MediaRepository<NewsMedia> {
  const NewsMediaRepository();

  @override
  String get path => newsMediaURL;

  @override
  String get ofOne => 'da notícia';

  @override
  String get ofMany => 'das notícias';

  @override
  NewsMedia fromMap(Map<String, dynamic> map) => NewsMedia.fromMap(map);

  @override
  Map<String, dynamic> toMap(NewsMedia media) => media.toMap();

  @override
  int? ownerIdOf(NewsMedia media) => media.news?.id;

  Future<List<NewsMedia>> findByNewsId(int id) => findByOwnerId(id);
}
