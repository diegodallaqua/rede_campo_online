import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/models/project_types.dart';
import '../../../core/repositories/token_repository.dart';

class ProjectTypesRepository {
  Future<List<ProjectTypes>> findAll() async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$projectTypesURL?take=100');

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
        final decoded = jsonDecode(response.body);

        List<dynamic> data;
        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map && decoded.containsKey('data')) {
          data = decoded['data'] as List<dynamic>;
        } else {
          return [];
        }

        return data
            .map((t) => ProjectTypes.fromMap(t as Map<String, dynamic>))
            .toList();
      } else {
        return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
      }
    } catch (e, s) {
      log('ProjectTypesRepository: Erro ao buscar Tipos de Projeto:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar tipos de projeto');
    }
  }
}
