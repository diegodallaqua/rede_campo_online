import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/stores/filter_search_store.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/repositories/token_repository.dart';
import '../models/members.dart';

class MembersRepository {
  Future<Members> createMember(Members member) async {
    final url = Uri.parse(baseURL + membersURL);
    final token = await TokenRepository().getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(member.toMap()),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final map = decoded is Map<String, dynamic>
            ? (decoded.containsKey('data')
                ? decoded['data'] as Map<String, dynamic>
                : decoded)
            : decoded as Map<String, dynamic>;
        return Members.fromMap(map);
      }
      if (response.statusCode == 204) {
        return Members();
      }
      return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
    } catch (e, s) {
      log('MembersRepository: Erro ao criar Membro.',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao criar Membro');
    }
  }

  Future<List<Members>> findAllMembers({
    int? page = 1,
    FilterSearchStore? filterSearchStore,
    int take = 15,
  }) async {
    final token = await TokenRepository().getToken();

    final url = Uri.parse('$baseURL$membersURL').replace(queryParameters: {
      'page': '$page',
      'take': '$take',
      if (filterSearchStore != null && filterSearchStore.search.isNotEmpty)
        'search': filterSearchStore.search,
    });

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'];
        return data.map((m) => Members.fromMap(m)).toList();
      } else {
        return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
      }
    } catch (e, s) {
      log('MembersRepository: Erro ao buscar Membros:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar Membros');
    }
  }

  Future<void> editMember(Members member) async {
    final url = Uri.parse(baseURL + membersURL + member.id!.toString());
    final token = await TokenRepository().getToken();

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(member.toMap()),
      );

      if (response.statusCode != 200 &&
          response.statusCode != 204 &&
          response.statusCode != 201) {
        // 200 OK / 204 No Content / 201 Created
        return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
      }
    } catch (e, s) {
      log('MembersRepository: Erro ao editar Membro:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao editar Membro');
    }
  }

  Future<void> deleteMember(String id) async {
    final url = Uri.parse(baseURL + membersURL + id);
    final token = await TokenRepository().getToken();

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        // 200 OK / 204 No Content
        return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
      }
    } catch (e, s) {
      log('MembersRepository: Erro ao deletar Membro:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao deletar Membro');
    }
  }
}
