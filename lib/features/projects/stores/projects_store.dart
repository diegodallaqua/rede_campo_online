import 'package:mobx/mobx.dart';

import '../../../core/stores/media_map_store.dart';
import '../../../core/stores/paged_store.dart';
import '../models/project_media.dart';
import '../models/projects.dart';
import '../repositories/project_media_repository.dart';
import '../repositories/projects_repository.dart';

class ProjectsStore extends PagedStore<Projects> {
  ProjectsStore({super.pageSize = 3}) {
    loadMedia();
  }

  final _repository = ProjectsRepository();

  @override
  Future<List<Projects>> fetchPage(int page) => _repository.findAllProjects(
        page: page,
        search: filterStore.search,
        take: pageSize,
      );

  late final _media = MediaMapStore<ProjectMedia>(
    fetchAll: const ProjectMediaRepository().findAll,
    ownerId: (m) => m.project?.id,
    logLabel: 'ProjectsStore',
  );

  ObservableMap<int, ProjectMedia> get mediaMap => _media.map;

  Future<void> loadMedia() => _media.load();
}
