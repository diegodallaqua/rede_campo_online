import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../core/stores/base_store.dart';
import '../../../core/stores/filter_search_store.dart';
import '../models/academic_work.dart';
import '../repositories/academic_work_repository.dart';

part 'academic_work_store.g.dart';

class AcademicWorkStore = AcademicWorkStoreBase with _$AcademicWorkStore;

abstract class AcademicWorkStoreBase extends BaseStore<AcademicWork>
    with Store {
  final AcademicWorkRepository _repository = AcademicWorkRepository();

  AcademicWorkStoreBase({this.pageSize = 15}) {
    loadData();
  }

  final int pageSize;

  List<AcademicWork> _cachedAcademicWorks = [];

  @observable
  FilterSearchStore filterStore = FilterSearchStore();

  FilterSearchStore get getCloneFilterStore => filterStore.cloneFilter();

  @action
  void setFilter(FilterSearchStore value) {
    filterStore = value;
    setPage(1);
    if (_cachedAcademicWorks.isEmpty) {
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
    _cachedAcademicWorks = [];
    resetPage();
  }

  @action
  void goToPage(int targetPage) {
    if (loading || targetPage == _page) return;
    setPage(targetPage);
    if (_cachedAcademicWorks.isNotEmpty) {
      _applyPage();
    } else {
      setLastPage(false);
      setData([]);
      loadData();
    }
  }

  @action
  void resetPage() {
    _cachedAcademicWorks = [];
    setPage(1);
    setLastPage(false);
    setData([]);
    loadData();
  }

  void _applyPage() {
    final query = filterStore.search.toLowerCase().trim();
    final filtered = query.isEmpty
        ? _cachedAcademicWorks
        : _cachedAcademicWorks
            .where((r) =>
                (r.publication?.title ?? '').toLowerCase().contains(query))
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
      if (_cachedAcademicWorks.isEmpty) {
        _cachedAcademicWorks = await _repository.findAllAcademicWorks(
          filterSearchStore: filterStore,
        );
      }
      _applyPage();
    } catch (e, s) {
      log(
        'AcademicWorkStore: Erro ao carregar Trabalhos Acadêmicos (página $_page)',
        error: e.toString(),
        stackTrace: s,
      );
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
