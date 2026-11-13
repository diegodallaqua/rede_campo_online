import '../global/constants/api_constants.dart';
import '../network/api_client.dart';
import '../models/organizations.dart';

class OrganizationsRepository {
  final _api = const ApiClient();

  Future<List<Organizations>> findAll() => _api.getList(
        organizationsURL,
        Organizations.fromMap,
        query: {'take': 100},
        errorMessage: 'Erro ao buscar Organizações',
      );
}
