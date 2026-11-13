import '../global/constants/api_constants.dart';
import '../network/api_client.dart';
import '../models/academic_work_types.dart';

class AcademicWorkTypesRepository {
  final _api = const ApiClient();

  Future<List<AcademicWorkType>> findAll() => _api.getList(
        academicWorkTypesURL,
        AcademicWorkType.fromMap,
        query: {'take': 100},
        errorMessage: 'Erro ao buscar Tipos de Trabalho Acadêmico',
      );
}
