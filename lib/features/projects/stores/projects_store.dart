import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../core/utils/stores/filter_search_store.dart';
import '../models/projects.dart';
import '../../../core/utils/stores/base_store.dart';
import '../repositories/projects_repository.dart';

part 'projects_store.g.dart';

class ProjectsStore = ProjectsStoreBase with _$ProjectsStore;

abstract class ProjectsStoreBase extends BaseStore<Projects> with Store {
  final ProjectsRepository _repository = ProjectsRepository();

  ProjectsStoreBase() {
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

  // Computed's — listagem completa
  @computed
  int get itemCount => _lastPage ? list.length : list.length + 1;

  @computed
  bool get showProgress => loading && list.isEmpty;

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
    list.clear();
    loadData();
  }

  static const int _pageSize = 5;

  @action
  void _addNewItems(List<Projects> newItems) {
    if (newItems.length < _pageSize) _lastPage = true;
    list.addAll(newItems);
  }

  Future<void> loadData() async {
    if (_page == 1) {
      await fetchData(
        'projects:search=${filterStore.search}',
        () => _repository.findAllProjects(
          page: _page,
          filterSearchStore: filterStore,
        ),
      );
      if (list.length < _pageSize) _lastPage = true;
    } else {
      // Páginas subsequentes, sem cache para não conflitar.
      setLoading(true);
      try {
        final result = await _repository.findAllProjects(
          page: _page,
          filterSearchStore: filterStore,
        );
        _addNewItems(result);
      } catch (e, s) {
        log(
          'ProjectsStore: Erro ao carregar Projetos (página $_page)',
          error: e.toString(),
          stackTrace: s,
        );
        setError(e.toString());
      } finally {
        setLoading(false);
      }
    }
  }
}
