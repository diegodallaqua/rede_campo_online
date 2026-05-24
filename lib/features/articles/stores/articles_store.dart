import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../core/utils/stores/base_store.dart';
import '../../../core/utils/stores/filter_search_store.dart';
import '../models/articles.dart';
import '../repositories/articles_repository.dart';

part 'articles_store.g.dart';

class ArticlesStore = ArticlesStoreBase with _$ArticlesStore;

abstract class ArticlesStoreBase extends BaseStore<Articles> with Store {
  final ArticlesRepository _repository = ArticlesRepository();

  ArticlesStoreBase({this.pageSize = 4}) {
    loadData();
  }

  final int pageSize;

  List<Articles> _cachedArticles = [];

  @observable
  FilterSearchStore filterStore = FilterSearchStore();

  FilterSearchStore get getCloneFilterStore => filterStore.cloneFilter();

  @action
  void setFilter(FilterSearchStore value) {
    filterStore = value;
    setPage(1);
    if (_cachedArticles.isEmpty) {
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
    _cachedArticles = [];
    resetPage();
  }

  @action
  void goToPage(int targetPage) {
    if (loading || targetPage == _page) return;
    setPage(targetPage);
    if (_cachedArticles.isNotEmpty) {
      _applyPage();
    } else {
      setLastPage(false);
      setData([]);
      loadData();
    }
  }

  @action
  void resetPage() {
    _cachedArticles = [];
    setPage(1);
    setLastPage(false);
    setData([]);
    loadData();
  }

  void _applyPage() {
    final query = filterStore.search.toLowerCase().trim();
    final filtered = query.isEmpty
        ? _cachedArticles
        : _cachedArticles
            .where((a) =>
                (a.publication?.title ?? '').toLowerCase().contains(query) ||
                (a.journal_name ?? '').toLowerCase().contains(query) ||
                (a.publisher ?? '').toLowerCase().contains(query))
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
      if (_cachedArticles.isEmpty) {
        _cachedArticles = await _repository.findAllArticles(
          filterSearchStore: filterStore,
        );
      }
      _applyPage();
    } catch (e, s) {
      log(
        'ArticlesStore: Erro ao carregar Artigos (página $_page)',
        error: e.toString(),
        stackTrace: s,
      );
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
