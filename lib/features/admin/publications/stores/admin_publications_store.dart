import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../../core/utils/stores/base_store.dart';

import '../../../../core/utils/stores/filter_search_store.dart';
import '../../../publications/models/publications.dart';
import '../../../publications/repositories/publications_repository.dart';

part 'admin_publications_store.g.dart';

class AdminPublicationsStore = AdminPublicationsStoreBase
    with _$AdminPublicationsStore;

abstract class AdminPublicationsStoreBase extends BaseStore<Publications>
    with Store {
  final PublicationsRepository _repository = PublicationsRepository();

  AdminPublicationsStoreBase({this.pageSize = 12}) {
    loadData();
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
  }

  void resetPage() {
    setPage(1);
    _lastPage = false;
    _lastPageKnown = false;
    list.clear();
    loadData();
  }

  @action
  void _addNewItems(List<Publications> newItems) {
    if (newItems.length < pageSize) _lastPage = true;
    list.addAll(newItems);
  }

  Future<void> loadData() async {
    if (_page == 1) {
      await fetchData(
        'publications:search=${filterStore.search}',
        () => _repository.findAllPublications(
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
        final result = await _repository.findAllPublications(
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

  // Verifica antecipadamente se a próxima página existe, evitando que a
  // paginação pisque ao exibir e remover uma página vazia.
  Future<void> _peekNextPage(int forPage) async {
    try {
      final peek = await _repository.findAllPublications(
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
}
