import '../../../core/global/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/members.dart';

class MembersRepository {
  final _api = const ApiClient();

  Future<Members> createMember(Members member) async {
    final map = await _api.post(membersURL, member.toMap(),
        errorMessage: 'Erro ao criar Membro');
    return map == null ? Members() : Members.fromMap(map);
  }

  Future<List<Members>> findAllMembers(
          {int? page = 1, String? search, int take = 15}) =>
      _api.getList(
        membersURL,
        Members.fromMap,
        query: {
          'page': page,
          'take': take,
          if (search != null && search.isNotEmpty) 'search': search,
        },
        errorMessage: 'Erro ao buscar Membros',
      );

  Future<void> editMember(Members member) =>
      _api.put('$membersURL${member.id}', member.toMap(),
          errorMessage: 'Erro ao editar Membro');

  Future<void> deleteMember(String id) =>
      _api.delete('$membersURL$id', errorMessage: 'Erro ao deletar Membro');
}
