import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../core/stores/media_map_store.dart';
import '../../../core/stores/paged_store.dart';
import '../models/news.dart';
import '../models/news_media.dart';
import '../repositories/news_media_repository.dart';
import '../repositories/news_repository.dart';

part 'news_store.g.dart';

class NewsStore = NewsStoreBase with _$NewsStore;

abstract class NewsStoreBase extends PagedStore<News> with Store {
  /// [loadList] carrega a listagem paginada; a Home usa só as recentes.
  NewsStoreBase({super.pageSize = 15, bool loadList = true})
      : super(peekNextPage: false, autoLoad: loadList) {
    loadMedia();
  }

  final _repository = NewsRepository();

  @override
  Future<List<News>> fetchPage(int page) => _repository.findAllNews(
        page: page,
        search: filterStore.search,
        take: pageSize,
      );

  // Notícias recentes - exclusivas para a Home Page
  @observable
  ObservableList<News> recentNews = ObservableList<News>();

  @observable
  bool isLoadingRecent = false;

  @observable
  String? recentNewsError;

  @computed
  bool get showRecentProgress => isLoadingRecent && recentNews.isEmpty;

  @action
  Future<void> loadRecentNews() async {
    // Evita fetch duplicado se já estiver carregando.
    if (isLoadingRecent) return;

    isLoadingRecent = true;
    recentNewsError = null;

    try {
      final result = await _repository.findAllNews(page: 1);
      recentNews
        ..clear()
        ..addAll(result);
    } catch (e, s) {
      log('NewsStore: Erro ao carregar Notícias recentes',
          error: e.toString(), stackTrace: s);
      recentNewsError = e.toString();
    } finally {
      isLoadingRecent = false;
    }
  }

  /// Recarrega as notícias recentes da Home sem afetar a listagem completa.
  @action
  Future<void> refreshRecentNews() async {
    recentNews.clear();
    await loadRecentNews();
  }

  late final _media = MediaMapStore<NewsMedia>(
    fetchAll: const NewsMediaRepository().findAll,
    ownerId: (m) => m.news?.id,
    logLabel: 'NewsStore',
  );

  ObservableMap<int, NewsMedia> get mediaMap => _media.map;

  Future<void> loadMedia() => _media.load();
}
