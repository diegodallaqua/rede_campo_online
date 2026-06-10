import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/utils/repositories/token_repository.dart';
import '../models/research_areas.dart';

class ResearchAreasRepository {
  Future<List<ResearchAreas>> findAll() async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$researchAreasURL');

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
        return data.map((e) => ResearchAreas.fromMap(e)).toList();
      }

      return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
    } catch (e, s) {
      log('Repository: Erro ao buscar Áreas de Pesquisa:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar Áreas de Pesquisa');
    }
  }
}
