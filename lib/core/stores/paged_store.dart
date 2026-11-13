import 'dart:developer';

import 'package:mobx/mobx.dart';

import 'base_store.dart';
import 'filter_search_store.dart';

part 'paged_store.g.dart';

/// [BaseStore] com paginação no servidor, busca e "peek" da próxima página.
/// Subclasses implementam apenas [fetchPage].
abstract class PagedStore<T> = PagedStoreBase<T> with _$PagedStore<T>;

abstract class PagedStoreBase<T> extends BaseStore<T> with Store {
  /// [peekNextPage] consulta a página seguinte para saber se ela existe.
  /// [autoLoad] carrega a primeira página ao criar o store.
  PagedStoreBase({
    this.pageSize = 12,
    this.peekNextPage = true,
    bool autoLoad = true,
  }) {
    if (autoLoad) loadData();
  }

  final int pageSize;
  final bool peekNextPage;

  /// Busca uma página no repositório, aplicando [filterStore].
  Future<List<T>> fetchPage(int page);

  final FilterSearchStore filterStore = FilterSearchStore();

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
      // Páginas seguintes sem cache, para não conflitar.
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

  // Checa a próxima página antes, evitando que a paginação pisque.
  Future<void> _peekNextPage(int forPage) async {
    if (!peekNextPage) return;
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
