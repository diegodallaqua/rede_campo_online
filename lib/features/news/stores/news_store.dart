import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../core/stores/base_store.dart';
import '../../../core/stores/filter_search_store.dart';
import '../models/news.dart';
import '../models/news_media.dart';
import '../repositories/news_media_repository.dart';
import '../repositories/news_repository.dart';

part 'news_store.g.dart';

class NewsStore = NewsStoreBase with _$NewsStore;

abstract class NewsStoreBase extends BaseStore<News> with Store {
  final NewsRepository _repository = NewsRepository();
  final NewsMediaRepository _mediaRepository = NewsMediaRepository();

  NewsStoreBase({this.pageSize = 15}) {
    loadData();
    loadMedia();
  }

  final int pageSize;

  @observable
  FilterSearchStore filterStore = FilterSearchStore();

  FilterSearchStore get getCloneFilterStore => filterStore.cloneFilter();

  @action
  void setFilter(FilterSearchStore value) {
    filterStore = value;
    resetPage();
  }

  // Paginação da listagem completa
  @readonly
  int _page = 1;

  @action
  void setPage(int value) => _page = value;

  @readonly
  bool _lastPage = false;

  @action
  void setLastPage(bool value) => _lastPage = value;

  // Computed's - listagem completa
  @computed
  int get itemCount => _lastPage ? list.length : list.length + 1;

  @computed
  bool get showProgress => loading && list.isEmpty;

  // Notícias recentes - exclusivas para a Home Page
  @observable
  ObservableList<News> recentNews = ObservableList<News>();

  @observable
  bool isLoadingRecent = false;

  @observable
  String? recentNewsError;

  @computed
  bool get showRecentProgress => isLoadingRecent && recentNews.isEmpty;

  // Ações - listagem completa
  @action
  void loadNextPage() {
    if (list.isNotEmpty) {
      _page++;
      loadData();
    }
  }

  void goToPage(int targetPage) {
    if (loading || targetPage == _page) return;
    setPage(targetPage);
    setLastPage(false);
    setData([]);
    loadData();
  }

  @action
  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 100));
    resetPage();
  }

  void resetPage() {
    setPage(1);
    _lastPage = false;
    list.clear();
    loadData();
  }

  @action
  void _addNewItems(List<News> newItems) {
    if (newItems.length < pageSize) _lastPage = true;
    list.addAll(newItems);
  }

  Future<void> loadData() async {
    if (_page == 1) {
      await fetchData(
        () => _repository.findAllNews(
          page: _page,
          filterSearchStore: filterStore,
          take: pageSize,
        ),
      );
      if (list.length < pageSize) _lastPage = true;
    } else {
      // Páginas subsequentes, sem cache para não conflitar.
      setLoading(true);
      try {
        final result = await _repository.findAllNews(
          page: _page,
          filterSearchStore: filterStore,
          take: pageSize,
        );
        _addNewItems(result);
      } catch (e, s) {
        log(
          'NewsStore: Erro ao carregar Notícias (página $_page)',
          error: e.toString(),
          stackTrace: s,
        );
        setError(e.toString());
      } finally {
        setLoading(false);
      }
    }
  }

  // Ações - Home Page (Listagem das notícias Recentes)
  @action
  Future<void> loadRecentNews({int limit = 10}) async {
    // Evita fetch duplicado se já estiver carregando.
    if (isLoadingRecent) return;

    isLoadingRecent = true;
    recentNewsError = null;

    try {
      final result = await _repository.findAllNews(
        page: 1,
        //limit: limit,
      );
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
  Future<void> refreshRecentNews({int limit = 5}) async {
    recentNews.clear();
    await loadRecentNews(limit: limit);
  }

  // Mídias das notícias
  @observable
  ObservableMap<int, NewsMedia> mediaMap = ObservableMap<int, NewsMedia>();

  @observable
  bool loadingMedia = false;

  @observable
  String? errorMedia;

  @action
  void _setLoadingMedia(bool value) => loadingMedia = value;

  @action
  void _setErrorMedia(String? value) => errorMedia = value;

  @action
  void _setMediaData(Map<int, NewsMedia> data) {
    mediaMap.clear();
    mediaMap.addAll(data);
  }

  Future<void> loadMedia() async {
    _setLoadingMedia(true);
    _setErrorMedia(null);
    try {
      final mediaList = await _mediaRepository.findAll();
      final map = <int, NewsMedia>{};
      for (final m in mediaList) {
        final newsId = m.news?.id;
        if (newsId != null && !map.containsKey(newsId)) {
          map[newsId] = m;
        }
      }
      _setMediaData(map);
    } catch (e, s) {
      log(
        'NewsStore: Erro ao carregar mídias das notícias',
        error: e.toString(),
        stackTrace: s,
      );
      _setErrorMedia(e.toString());
    } finally {
      _setLoadingMedia(false);
    }
  }
}
