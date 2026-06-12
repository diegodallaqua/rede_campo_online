import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/repositories/token_repository.dart';
import '../models/members.dart';

class MembersRepository {
  Future<List<Members>> findAllMembers({int? page = 1}) async {
    final token = await TokenRepository().getToken();

    final url = Uri.parse('$baseURL$membersURL').replace(queryParameters: {
      'page': '$page',
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
}
