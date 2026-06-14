import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../global/constants/api_constants.dart';
import '../models/member_roles.dart';
import '../utils/error_message_api.dart';
import 'token_repository.dart';

class MemberRolesRepository {
  Future<List<MemberRoles>> findAll() async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$memberRolesURL?take=100');

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
        return data.map((e) => MemberRoles.fromMap(e)).toList();
      }

      return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
    } catch (e, s) {
      log('Repository: Erro ao buscar Papéis de Membro:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar Papéis de Membro');
    }
  }
}
