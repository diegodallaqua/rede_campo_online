import '../../../core/global/constants/api_constants.dart';
import '../../../core/repositories/media_repository.dart';
import '../models/project_media.dart';

class ProjectMediaRepository extends MediaRepository<ProjectMedia> {
  const ProjectMediaRepository();

  @override
  String get path => projectMediaURL;

  @override
  String get ofOne => 'do projeto';

  @override
  String get ofMany => 'dos projetos';

  @override
  ProjectMedia fromMap(Map<String, dynamic> map) => ProjectMedia.fromMap(map);

  @override
  Map<String, dynamic> toMap(ProjectMedia media) => media.toMap();

  @override
  int? ownerIdOf(ProjectMedia media) => media.project?.id;

  Future<List<ProjectMedia>> findByProjectId(int id) => findByOwnerId(id);
}
