import 'package:mobx/mobx.dart';

import '../../../../core/stores/media_map_store.dart';
import '../../../../core/stores/paged_store.dart';
import '../../../news/models/news.dart';
import '../../../news/models/news_media.dart';
import '../../../news/repositories/news_media_repository.dart';
import '../../../news/repositories/news_repository.dart';

part 'admin_news_store.g.dart';

class AdminNewsStore = AdminNewsStoreBase with _$AdminNewsStore;

abstract class AdminNewsStoreBase extends PagedStore<News> with Store {
  final NewsRepository _repository = NewsRepository();

  AdminNewsStoreBase({super.pageSize}) {
    loadMedia();
  }

  // Estado de carregamento/erro da listagem, exposto como observável próprio
  // do store (espelha o estado herdado de BaseStore via setLoading/setError).
  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @override
  @action
  void setLoading(bool value) {
    super.setLoading(value);
    isLoading = value;
  }

  @override
  @action
  void setError(String? message) {
    super.setError(message);
    errorMessage = message;
  }

  @override
  Future<List<News>> fetchPage(int page) => _repository.findAllNews(
        page: page,
        filterSearchStore: filterStore,
        take: pageSize,
      );

  @override
  Future<void> refreshData() async {
    await super.refreshData();
    loadMedia();
  }

  // Mídias das notícias
  late final MediaMapStore<NewsMedia> _media = MediaMapStore(
    fetchAll: NewsMediaRepository().findAll,
    ownerId: (m) => m.news?.id,
    logLabel: 'AdminNewsStore',
  );

  ObservableMap<int, NewsMedia> get mediaMap => _media.map;

  Future<void> loadMedia() => _media.load();
}
