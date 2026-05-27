import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/utils/repositories/token_repository.dart';
import '../models/project_media.dart';

class ProjectMediaRepository {
  Future<List<ProjectMedia>> findAll() async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$projectMediaURL?take=100');

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
            .map((m) => ProjectMedia.fromMap(m as Map<String, dynamic>))
            .toList();
      } else {
        return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
      }
    } catch (e, s) {
      log('ProjectMediaRepository: Erro ao buscar ProjectMedia:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar imagens dos projetos');
    }
  }
}
