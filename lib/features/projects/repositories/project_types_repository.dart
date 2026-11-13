import '../../../core/global/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/models/project_types.dart';

class ProjectTypesRepository {
  final _api = const ApiClient();

  Future<List<ProjectTypes>> findAll() => _api.getList(
        projectTypesURL,
        ProjectTypes.fromMap,
        query: {'take': 100},
        errorMessage: 'Erro ao buscar tipos de projeto',
      );
}
