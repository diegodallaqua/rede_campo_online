import 'dart:developer';

import 'package:mobx/mobx.dart';

import 'base_store.dart';
import 'filter_search_store.dart';

part 'paged_store.g.dart';

/// Estende [BaseStore] com paginação numerada, busca e antecipação da
/// existência da próxima página ("peek"), padrão compartilhado por todas as
/// listagens do painel administrativo.
///
/// Subclasses implementam apenas [fetchPage].
abstract class PagedStore<T> = _PagedStore<T> with _$PagedStore<T>;

abstract class _PagedStore<T> extends BaseStore<T> with Store {
  _PagedStore({this.pageSize = 12}) {
    loadData();
  }

  final int pageSize;

  /// Busca uma página de resultados no repositório da entidade.
  Future<List<T>> fetchPage(int page);

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
  void _addNewItems(List<T> newItems) {
    if (newItems.length < pageSize) _lastPage = true;
    list.addAll(newItems);
  }

  Future<void> loadData() async {
    if (_page == 1) {
      await fetchData(() => fetchPage(_page));
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
        final result = await fetchPage(_page);
        _addNewItems(result);
        if (_lastPage) {
          setLastPageKnown(true);
        } else {
          _peekNextPage(_page);
        }
      } catch (e, s) {
        log(
          '$runtimeType: Erro ao carregar dados (página $_page)',
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
      final peek = await fetchPage(forPage + 1);
      if (_page == forPage) {
        if (peek.isEmpty) setLastPage(true);
        setLastPageKnown(true);
      }
    } catch (_) {
      if (_page == forPage) setLastPageKnown(true);
    }
  }
}
