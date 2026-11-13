import '../global/constants/api_constants.dart';
import '../network/api_client.dart';
import '../models/contributor_roles.dart';

class ContributorRolesRepository {
  final _api = const ApiClient();

  Future<List<ContributorRoles>> findAll() => _api.getList(
        contributorRolesURL,
        ContributorRoles.fromMap,
        query: {'take': 100},
        errorMessage: 'Erro ao buscar Papéis de Contribuição',
      );
}
