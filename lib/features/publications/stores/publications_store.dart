import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../core/stores/base_store.dart';
import '../../../core/stores/filter_search_store.dart';
import '../models/publications.dart';
import '../repositories/publications_repository.dart';

part 'publications_store.g.dart';

class PublicationsStore = PublicationsStoreBase with _$PublicationsStore;

abstract class PublicationsStoreBase extends BaseStore<Publications>
    with Store {
  final PublicationsRepository _repository = PublicationsRepository();

  PublicationsStoreBase() {
    loadData();
  }

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
  ObservableList<Publications> recentPublications =
      ObservableList<Publications>();

  @observable
  bool isLoadingRecent = false;

  @observable
  String? recentPublicationsError;

  @computed
  bool get showRecentProgress => isLoadingRecent && recentPublications.isEmpty;

  // Ações - listagem completa
  @action
  void loadNextPage() {
    if (list.isNotEmpty) {
      _page++;
      loadData();
    }
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
  void _addNewItems(List<Publications> newItems) {
    if (newItems.length < 15) _lastPage = true;
    list.addAll(newItems);
  }

  Future<void> loadData() async {
    if (_page == 1) {
      await fetchData(
        () => _repository.findAllPublications(
          page: _page,
          filterSearchStore: filterStore,
        ),
      );
      if (list.length < 15) _lastPage = true;
    } else {
      // Páginas subsequentes, sem cache para não conflitar.
      setLoading(true);
      try {
        final result = await _repository.findAllPublications(
          page: _page,
          filterSearchStore: filterStore,
        );
        _addNewItems(result);
      } catch (e, s) {
        log(
          'PublicationsStore: Erro ao carregar Publicações (página $_page)',
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
  Future<void> loadRecentPublications({int limit = 10}) async {
    // Evita fetch duplicado se já estiver carregando.
    if (isLoadingRecent) return;

    isLoadingRecent = true;
    recentPublicationsError = null;

    try {
      final result = await _repository.findAllPublications(
        page: 1,
        //limit: limit,
      );
      recentPublications
        ..clear()
        ..addAll(result);
    } catch (e, s) {
      log('PublicationsStore: Erro ao carregar Publicações recentes',
          error: e.toString(), stackTrace: s);
      recentPublicationsError = e.toString();
    } finally {
      isLoadingRecent = false;
    }
  }

  /// Recarrega as notícias recentes da Home sem afetar a listagem completa.
  @action
  Future<void> refreshRecentPublications({int limit = 5}) async {
    recentPublications.clear();
    await loadRecentPublications(limit: limit);
  }
}
