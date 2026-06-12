import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/repositories/token_repository.dart';
import '../models/events_media.dart';

class EventMediaRepository {
  /// Tenta extrair a mensagem de erro JSON da resposta; se o corpo não for
  /// JSON (ex.: página HTML de erro 404/500), devolve uma mensagem legível
  /// com o status HTTP em vez de estourar um FormatException.
  Object _parseError(http.Response response, String fallback) {
    try {
      return ErrorsAPI.fromMap(
          json.decode(response.body) as Map<String, dynamic>);
    } catch (_) {
      return '$fallback (HTTP ${response.statusCode})';
    }
  }

  Future<EventMedia> create(EventMedia media) async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$eventMediaURL');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(media.toMap()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return EventMedia.fromMap(
            jsonDecode(response.body) as Map<String, dynamic>);
      }
      return Future.error(
          _parseError(response, 'Erro ao salvar imagem do evento'));
    } catch (e, s) {
      log('EventMediaRepository: erro ao criar EventMedia',
          error: e.toString(), stackTrace: s);
      return Future.error(e is String ? e : 'Erro ao salvar imagem do evento');
    }
  }

  Future<List<EventMedia>> findByEventId(int eventId) async {
    final all = await findAll();
    return all.where((m) => m.event?.id == eventId).toList();
  }

  Future<void> deleteMedia(int id) async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$eventMediaURL$id');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) return;

      return Future.error(
          _parseError(response, 'Erro ao remover imagem do evento'));
    } catch (e, s) {
      log('EventMediaRepository: erro ao deletar EventMedia',
          error: e.toString(), stackTrace: s);
      return Future.error(e is String ? e : 'Erro ao remover imagem do evento');
    }
  }

  Future<List<EventMedia>> findAll() async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$eventMediaURL')
        .replace(queryParameters: {'take': '100'});

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
        final List<dynamic> data = decoded is List
            ? decoded
            : (decoded['data'] as List<dynamic>? ?? []);
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
