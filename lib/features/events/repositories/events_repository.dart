import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/utils/repositories/token_repository.dart';
import '../models/events.dart';

class EventsRepository {
  Future<List<Events>> findByProjectId(int projectId) async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$eventsURL').replace(queryParameters: {
      'project_id': '$projectId',
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
        final decoded = jsonDecode(response.body);
        final List<dynamic> data =
            decoded is List ? decoded : (decoded['data'] as List<dynamic>? ?? []);
        return data.map((e) => Events.fromMap(e as Map<String, dynamic>)).toList();
      } else {
        return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
      }
    } catch (e, s) {
      log(
        'EventsRepository: Erro ao buscar eventos do projeto $projectId',
        error: e.toString(),
        stackTrace: s,
      );
      return Future.error('Erro ao buscar eventos do projeto');
    }
  }
}
