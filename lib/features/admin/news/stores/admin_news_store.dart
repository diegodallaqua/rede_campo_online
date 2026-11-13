import 'package:mobx/mobx.dart';

import '../../../../core/stores/media_map_store.dart';
import '../../../../core/stores/paged_store.dart';
import '../../../news/models/news.dart';
import '../../../news/models/news_media.dart';
import '../../../news/repositories/news_media_repository.dart';
import '../../../news/repositories/news_repository.dart';

class AdminNewsStore extends PagedStore<News> {
  AdminNewsStore({super.pageSize}) {
    loadMedia();
  }

  final _repository = NewsRepository();

  @override
  Future<List<News>> fetchPage(int page) => _repository.findAllNews(
        page: page,
        search: filterStore.search,
        take: pageSize,
      );

  @override
  Future<void> refreshData() async {
    await super.refreshData();
    loadMedia();
  }

  late final _media = MediaMapStore<NewsMedia>(
    fetchAll: const NewsMediaRepository().findAll,
    ownerId: (m) => m.news?.id,
    logLabel: 'AdminNewsStore',
  );

  ObservableMap<int, NewsMedia> get mediaMap => _media.map;

  Future<void> loadMedia() => _media.load();
}
