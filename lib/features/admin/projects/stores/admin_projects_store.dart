import 'package:mobx/mobx.dart';

import '../../../../core/stores/media_map_store.dart';
import '../../../../core/stores/paged_store.dart';
import '../../../projects/models/projects.dart';
import '../../../projects/models/project_media.dart';
import '../../../projects/repositories/project_media_repository.dart';
import '../../../projects/repositories/projects_repository.dart';

class AdminProjectsStore extends PagedStore<Projects> {
  AdminProjectsStore({super.pageSize}) {
    loadMedia();
  }

  final _repository = ProjectsRepository();

  @override
  Future<List<Projects>> fetchPage(int page) => _repository.findAllProjects(
        page: page,
        search: filterStore.search,
        take: pageSize,
      );

  @override
  Future<void> refreshData() async {
    await super.refreshData();
    loadMedia();
  }

  late final _media = MediaMapStore<ProjectMedia>(
    fetchAll: const ProjectMediaRepository().findAll,
    ownerId: (m) => m.project?.id,
    logLabel: 'AdminProjectsStore',
  );

  ObservableMap<int, ProjectMedia> get mediaMap => _media.map;

  Future<void> loadMedia() => _media.load();
}
