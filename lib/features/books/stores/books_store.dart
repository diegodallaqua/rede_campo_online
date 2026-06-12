import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../core/stores/base_store.dart';
import '../../../core/stores/filter_search_store.dart';
import '../models/books.dart';
import '../repositories/books_repository.dart';

part 'books_store.g.dart';

class BooksStore = BooksStoreBase with _$BooksStore;

abstract class BooksStoreBase extends BaseStore<Books> with Store {
  final BooksRepository _repository = BooksRepository();

  BooksStoreBase({this.pageSize = 15}) {
    loadData();
  }

  final int pageSize;

  List<Books> _cachedBooks = [];

  @observable
  FilterSearchStore filterStore = FilterSearchStore();

  FilterSearchStore get getCloneFilterStore => filterStore.cloneFilter();

  @action
  void setFilter(FilterSearchStore value) {
    filterStore = value;
    setPage(1);
    if (_cachedBooks.isEmpty) {
      setLastPage(false);
      setData([]);
      loadData();
    } else {
      _applyPage();
    }
  }

  @readonly
  int _page = 1;

  @action
  void setPage(int value) => _page = value;

  @readonly
  bool _lastPage = false;

  @action
  void setLastPage(bool value) => _lastPage = value;

  @computed
  int get itemCount => _lastPage ? list.length : list.length + 1;

  @computed
  bool get showProgress => loading && list.isEmpty;

  @action
  void loadNextPage() {
    if (!_lastPage) {
      setPage(_page + 1);
      _applyPage();
    }
  }

  @action
  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _cachedBooks = [];
    resetPage();
  }

  @action
  void goToPage(int targetPage) {
    if (loading || targetPage == _page) return;
    setPage(targetPage);
    if (_cachedBooks.isNotEmpty) {
      _applyPage();
    } else {
      setLastPage(false);
      setData([]);
      loadData();
    }
  }

  @action
  void resetPage() {
    _cachedBooks = [];
    setPage(1);
    setLastPage(false);
    setData([]);
    loadData();
  }

  void _applyPage() {
    final query = filterStore.search.toLowerCase().trim();
    final filtered = query.isEmpty
        ? _cachedBooks
        : _cachedBooks
            .where((b) =>
                (b.publication?.title ?? '').toLowerCase().contains(query) ||
                (b.publisher ?? '').toLowerCase().contains(query))
            .toList();
    final total = filtered.length;
    final start = (_page - 1) * pageSize;
    final end = (start + pageSize).clamp(0, total);
    setData(filtered.sublist(start.clamp(0, total), end));
    setLastPage(end >= total);
  }

  Future<void> loadData() async {
    setLoading(true);
    setError(null);
    try {
      if (_cachedBooks.isEmpty) {
        _cachedBooks = await _repository.findAllBooks(
          filterSearchStore: filterStore,
        );
      }
      _applyPage();
    } catch (e, s) {
      log(
        'BooksStore: Erro ao carregar Livros (página $_page)',
        error: e.toString(),
        stackTrace: s,
      );
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
