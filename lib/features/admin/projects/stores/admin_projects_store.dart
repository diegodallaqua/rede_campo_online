import 'package:mobx/mobx.dart';

import '../../../../core/stores/media_map_store.dart';
import '../../../../core/stores/paged_store.dart';
import '../../../projects/models/project_media.dart';
import '../../../projects/models/projects.dart';
import '../../../projects/repositories/project_media_repository.dart';
import '../../../projects/repositories/projects_repository.dart';

part 'admin_projects_store.g.dart';

class AdminProjectsStore = AdminProjectsStoreBase with _$AdminProjectsStore;

abstract class AdminProjectsStoreBase extends PagedStore<Projects> with Store {
  final ProjectsRepository _repository = ProjectsRepository();

  AdminProjectsStoreBase({super.pageSize}) {
    loadMedia();
  }

  // Estado de carregamento/erro da listagem, exposto como observável próprio
  // do store (espelha o estado herdado de BaseStore via setLoading/setError).
  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @override
  @action
  void setLoading(bool value) {
    super.setLoading(value);
    isLoading = value;
  }

  @override
  @action
  void setError(String? message) {
    super.setError(message);
    errorMessage = message;
  }

  @override
  Future<List<Projects>> fetchPage(int page) => _repository.findAllProjects(
        page: page,
        filterSearchStore: filterStore,
        take: pageSize,
      );

  @override
  Future<void> refreshData() async {
    await super.refreshData();
    loadMedia();
  }

  // Mídias dos projetos
  late final MediaMapStore<ProjectMedia> _media = MediaMapStore(
    fetchAll: ProjectMediaRepository().findAll,
    ownerId: (m) => m.project?.id,
    logLabel: 'AdminProjectsStore',
  );

  ObservableMap<int, ProjectMedia> get mediaMap => _media.map;

  Future<void> loadMedia() => _media.load();
}
