import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/utils/repositories/token_repository.dart';
import '../models/events_media.dart';

class EventMediaRepository {
  Future<List<EventMedia>> findAll() async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$eventMediaURL');

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
        return data
            .map((m) => EventMedia.fromMap(m as Map<String, dynamic>))
            .toList();
      } else {
        return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
      }
    } catch (e, s) {
      log(
        'EventMediaRepository: Erro ao buscar mídias de eventos',
        error: e.toString(),
        stackTrace: s,
      );
      return Future.error('Erro ao buscar imagens dos eventos');
    }
  }
}
