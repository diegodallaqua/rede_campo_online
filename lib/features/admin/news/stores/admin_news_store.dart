import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../../core/utils/stores/base_store.dart';

import '../../../../core/utils/stores/filter_search_store.dart';
import '../../../news/models/news.dart';
import '../../../news/models/news_media.dart';
import '../../../news/repositories/news_media_repository.dart';
import '../../../news/repositories/news_repository.dart';

part 'admin_news_store.g.dart';

class AdminNewsStore = AdminNewsStoreBase with _$AdminNewsStore;

abstract class AdminNewsStoreBase extends BaseStore<News> with Store {
  final NewsRepository _repository = NewsRepository();
  final NewsMediaRepository _mediaRepository = NewsMediaRepository();

  AdminNewsStoreBase({this.pageSize = 12}) {
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

  // true quando já se sabe se a próxima página existe ou não.
  @readonly
  bool _lastPageKnown = false;

  @action
  void setLastPageKnown(bool value) => _lastPageKnown = value;

  // Computed's — listagem completa
  @computed
  int get itemCount => _lastPage ? list.length : list.length + 1;

  @computed
  bool get showProgress => loading && list.isEmpty;

  // Notícias recentes — exclusivas para a Home Page
  @observable
  ObservableList<News> recentNews = ObservableList<News>();

  @observable
  bool isLoadingRecent = false;

  @observable
  String? recentNewsError;

  @computed
  bool get showRecentProgress => isLoadingRecent && recentNews.isEmpty;

  // Ações — listagem completa
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
    setLastPageKnown(false);
    setData([]);
    loadData();
  }

  @action
  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 100));
    resetPage();
    loadMedia();
  }

  void resetPage() {
    setPage(1);
    _lastPage = false;
    _lastPageKnown = false;
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
        'news:search=${filterStore.search}',
        () => _repository.findAllNews(
          page: _page,
          filterSearchStore: filterStore,
          take: pageSize,
        ),
      );
      if (list.length < pageSize) {
        _lastPage = true;
        _lastPageKnown = true;
      } else {
        _peekNextPage(_page);
      }
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
        if (_lastPage) {
          setLastPageKnown(true);
        } else {
          _peekNextPage(_page);
        }
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

  // Verifica antecipadamente se a próxima página existe, evitando que a
  // paginação pisque ao exibir e remover uma página vazia.
  Future<void> _peekNextPage(int forPage) async {
    try {
      final peek = await _repository.findAllNews(
        page: forPage + 1,
        filterSearchStore: filterStore,
        take: pageSize,
      );
      if (_page == forPage) {
        if (peek.isEmpty) setLastPage(true);
        setLastPageKnown(true);
      }
    } catch (_) {
      if (_page == forPage) setLastPageKnown(true);
    }
  }

  // Ações — Home Page (Listagem das notícias Recentes)
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
