import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../../core/utils/stores/base_store.dart';
import '../../../../core/utils/stores/filter_search_store.dart';
import '../../../projects/models/project_media.dart';
import '../../../projects/models/projects.dart';
import '../../../projects/repositories/project_media_repository.dart';
import '../../../projects/repositories/projects_repository.dart';

part 'admin_projects_store.g.dart';

class AdminProjectsStore = AdminProjectsStoreBase with _$AdminProjectsStore;

abstract class AdminProjectsStoreBase extends BaseStore<Projects> with Store {
  final ProjectsRepository _repository = ProjectsRepository();
  final ProjectMediaRepository _mediaRepository = ProjectMediaRepository();

  AdminProjectsStoreBase({this.pageSize = 12}) {
    loadData();
    loadMedia();
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
    loadMedia();
  }

  void resetPage() {
    setPage(1);
    _lastPage = false;
    _lastPageKnown = false;
    list.clear();
    loadData();
  }

  @action
  void _addNewItems(List<Projects> newItems) {
    if (newItems.length < pageSize) _lastPage = true;
    list.addAll(newItems);
  }

  Future<void> loadData() async {
    if (_page == 1) {
      await fetchData(
        'projects:search=${filterStore.search}',
        () => _repository.findAllProjects(
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
        final result = await _repository.findAllProjects(
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
          'AdminProjectsStore: Erro ao carregar Projetos (página $_page)',
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
      final peek = await _repository.findAllProjects(
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

  // Mídias dos projetos
  @observable
  ObservableMap<int, ProjectMedia> mediaMap =
      ObservableMap<int, ProjectMedia>();

  @observable
  bool loadingMedia = false;

  @observable
  String? errorMedia;

  @action
  void _setLoadingMedia(bool value) => loadingMedia = value;

  @action
  void _setErrorMedia(String? value) => errorMedia = value;

  @action
  void _setMediaData(Map<int, ProjectMedia> data) {
    mediaMap.clear();
    mediaMap.addAll(data);
  }

  Future<void> loadMedia() async {
    _setLoadingMedia(true);
    _setErrorMedia(null);
    try {
      final mediaList = await _mediaRepository.findAll();
      final map = <int, ProjectMedia>{};
      for (final m in mediaList) {
        final projectId = m.project?.id;
        if (projectId != null && !map.containsKey(projectId)) {
          map[projectId] = m;
        }
      }
      _setMediaData(map);
    } catch (e, s) {
      log(
        'AdminProjectsStore: Erro ao carregar mídias dos projetos',
        error: e.toString(),
        stackTrace: s,
      );
      _setErrorMedia(e.toString());
    } finally {
      _setLoadingMedia(false);
    }
  }
}
