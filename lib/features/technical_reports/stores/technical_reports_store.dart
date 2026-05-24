import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../core/utils/stores/base_store.dart';
import '../../../core/utils/stores/filter_search_store.dart';
import '../models/technical_reports.dart';
import '../repositories/technical_reports_repository.dart';

part 'technical_reports_store.g.dart';

class TechnicalReportsStore = TechnicalReportsStoreBase
    with _$TechnicalReportsStore;

abstract class TechnicalReportsStoreBase extends BaseStore<TechnicalReports>
    with Store {
  final TechnicalReportsRepository _repository = TechnicalReportsRepository();

  TechnicalReportsStoreBase({this.pageSize = 15}) {
    loadData();
  }

  final int pageSize;

  List<TechnicalReports> _cachedReports = [];

  @observable
  FilterSearchStore filterStore = FilterSearchStore();

  FilterSearchStore get getCloneFilterStore => filterStore.cloneFilter();

  @action
  void setFilter(FilterSearchStore value) {
    filterStore = value;
    _cachedReports = [];
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
    _cachedReports = [];
    resetPage();
  }

  @action
  void goToPage(int targetPage) {
    if (loading || targetPage == _page) return;
    setPage(targetPage);
    if (_cachedReports.isNotEmpty) {
      _applyPage();
    } else {
      setLastPage(false);
      setData([]);
      loadData();
    }
  }

  @action
  void resetPage() {
    _cachedReports = [];
    setPage(1);
    setLastPage(false);
    setData([]);
    loadData();
  }

  void _applyPage() {
    final total = _cachedReports.length;
    final start = (_page - 1) * pageSize;
    final end = (start + pageSize).clamp(0, total);
    setData(_cachedReports.sublist(start.clamp(0, total), end));
    setLastPage(end >= total);
  }

  Future<void> loadData() async {
    setLoading(true);
    setError(null);
    try {
      if (_cachedReports.isEmpty) {
        _cachedReports = await _repository.findAllTechnicalReports(
          filterSearchStore: filterStore,
        );
      }
      _applyPage();
    } catch (e, s) {
      log(
        'TechnicalReportsStore: Erro ao carregar Relatórios Técnicos (página $_page)',
        error: e.toString(),
        stackTrace: s,
      );
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
