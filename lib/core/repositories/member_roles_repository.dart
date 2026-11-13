import '../global/constants/api_constants.dart';
import '../network/api_client.dart';
import '../models/member_roles.dart';

class MemberRolesRepository {
  final _api = const ApiClient();

  Future<List<MemberRoles>> findAll() => _api.getList(
        memberRolesURL,
        MemberRoles.fromMap,
        query: {'take': 100},
        errorMessage: 'Erro ao buscar Papéis de Membro',
      );
}
