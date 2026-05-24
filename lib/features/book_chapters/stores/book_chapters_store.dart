import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../core/utils/stores/base_store.dart';
import '../../../core/utils/stores/filter_search_store.dart';
import '../models/book_chapters.dart';
import '../repositories/book_chapters_repository.dart';

part 'book_chapters_store.g.dart';

class BookChaptersStore = BookChaptersStoreBase with _$BookChaptersStore;

abstract class BookChaptersStoreBase extends BaseStore<BookChapters>
    with Store {
  final BookChaptersRepository _repository = BookChaptersRepository();

  BookChaptersStoreBase({this.pageSize = 15}) {
    loadData();
  }

  final int pageSize;

  List<BookChapters> _cachedChapters = [];

  @observable
  FilterSearchStore filterStore = FilterSearchStore();

  FilterSearchStore get getCloneFilterStore => filterStore.cloneFilter();

  @action
  void setFilter(FilterSearchStore value) {
    filterStore = value;
    _cachedChapters = [];
    resetPage();
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
    _cachedChapters = [];
    resetPage();
  }

  @action
  void goToPage(int targetPage) {
    if (loading || targetPage == _page) return;
    setPage(targetPage);
    if (_cachedChapters.isNotEmpty) {
      _applyPage();
    } else {
      setLastPage(false);
      setData([]);
      loadData();
    }
  }

  @action
  void resetPage() {
    _cachedChapters = [];
    setPage(1);
    setLastPage(false);
    setData([]);
    loadData();
  }

  void _applyPage() {
    final total = _cachedChapters.length;
    final start = (_page - 1) * pageSize;
    final end = (start + pageSize).clamp(0, total);
    setData(_cachedChapters.sublist(start.clamp(0, total), end));
    setLastPage(end >= total);
  }

  Future<void> loadData() async {
    setLoading(true);
    setError(null);
    try {
      if (_cachedChapters.isEmpty) {
        _cachedChapters = await _repository.findAllBookChapters(
          filterSearchStore: filterStore,
        );
      }
      _applyPage();
    } catch (e, s) {
      log(
        'BookChaptersStore: Erro ao carregar Capítulos (página $_page)',
        error: e.toString(),
        stackTrace: s,
      );
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
