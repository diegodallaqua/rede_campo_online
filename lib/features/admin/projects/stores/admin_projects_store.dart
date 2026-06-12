import 'package:mobx/mobx.dart';

import '../../../../core/stores/media_map_store.dart';
import '../../../../core/stores/paged_store.dart';
import '../../../projects/models/project_media.dart';
import '../../../projects/models/projects.dart';
import '../../../projects/repositories/project_media_repository.dart';
import '../../../projects/repositories/projects_repository.dart';

class AdminProjectsStore extends PagedStore<Projects> {
  final ProjectsRepository _repository = ProjectsRepository();

  AdminProjectsStore({super.pageSize}) {
    loadMedia();
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
