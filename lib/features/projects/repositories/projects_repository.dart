import '../../../core/global/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/projects.dart';

class ProjectsRepository {
  final _api = const ApiClient();

  Future<Projects> createProject(Projects project) async {
    final map = await _api.post(projectsURL, project.toMap(),
        errorMessage: 'Erro ao criar Projeto');
    return map == null ? Projects() : Projects.fromMap(map);
  }

  Future<List<Projects>> findAllProjects(
          {int? page = 1, String? search, int take = 3}) =>
      _api.getList(
        projectsURL,
        Projects.fromMap,
        query: {
          'page': page,
          'take': take,
          if (search != null && search.isNotEmpty) 'project_name': search,
        },
        errorMessage: 'Erro ao buscar Projetos',
      );

  Future<void> editProject(Projects project) =>
      _api.put('$projectsURL${project.id}', project.toMap(),
          errorMessage: 'Erro ao editar Projeto');

  Future<void> deleteProject(String id) =>
      _api.delete('$projectsURL$id', errorMessage: 'Erro ao deletar Projeto');
}
