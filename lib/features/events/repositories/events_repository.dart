import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/repositories/token_repository.dart';
import '../../../core/stores/filter_search_store.dart';
import '../models/events.dart';

class EventsRepository {
  Future<Events> createEvent(Events event) async {
    final url = Uri.parse(baseURL + eventsURL);
    final token = await TokenRepository().getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(event.toMap()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final map = decoded is Map<String, dynamic>
            ? (decoded.containsKey('data')
                ? decoded['data'] as Map<String, dynamic>
                : decoded)
            : decoded as Map<String, dynamic>;
        return Events.fromMap(map);
      }
      if (response.statusCode == 204) {
        return Events();
      }
      return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
    } catch (e, s) {
      log('EventsRepository: Erro ao criar Evento.',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao criar Evento');
    }
  }

  Future<List<Events>> findAllEvents(
      {int? page = 1,
      FilterSearchStore? filterSearchStore,
      int take = 15}) async {
    final token = await TokenRepository().getToken();

    final url = Uri.parse('$baseURL$eventsURL').replace(queryParameters: {
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
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded is List
            ? decoded
            : (decoded['data'] as List<dynamic>? ?? []);
        return data
            .map((e) => Events.fromMap(e as Map<String, dynamic>))
            .toList();
      } else {
        return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
      }
    } catch (e, s) {
      log('EventsRepository: Erro ao buscar Eventos:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar Eventos');
    }
  }

  Future<void> editEvent(Events event) async {
    final url = Uri.parse(baseURL + eventsURL + event.id!.toString());
    final token = await TokenRepository().getToken();

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(event.toMap()),
      );

      if (response.statusCode != 200 &&
          response.statusCode != 204 &&
          response.statusCode != 201) {
        return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
      }
    } catch (e, s) {
      log('EventsRepository: Erro ao editar Evento:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao editar Evento');
    }
  }

  Future<void> deleteEvent(String id) async {
    final url = Uri.parse(baseURL + eventsURL + id);
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
        return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
      }
    } catch (e, s) {
      log('EventsRepository: Erro ao deletar Evento:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao deletar Evento');
    }
  }

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
        final List<dynamic> data = decoded is List
            ? decoded
            : (decoded['data'] as List<dynamic>? ?? []);
        return data
            .map((e) => Events.fromMap(e as Map<String, dynamic>))
            .toList();
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

  Future<List<Events>> findUpcomingEvents({int page = 1, int take = 4}) async {
    final token = await TokenRepository().getToken();
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final url = Uri.parse('$baseURL$eventsURL').replace(queryParameters: {
      'page': '$page',
      'take': '$take',
      'date_from': today,
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
        final List<dynamic> data = decoded is List
            ? decoded
            : (decoded['data'] as List<dynamic>? ?? []);
        return data
            .map((e) => Events.fromMap(e as Map<String, dynamic>))
            .toList();
      } else {
        return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
      }
    } catch (e, s) {
      log(
        'EventsRepository: Erro ao buscar próximos eventos',
        error: e.toString(),
        stackTrace: s,
      );
      return Future.error('Erro ao buscar próximos eventos');
    }
  }

  Future<List<Events>> findRecentEvents({int take = 4}) async {
    final token = await TokenRepository().getToken();
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final url = Uri.parse('$baseURL$eventsURL').replace(queryParameters: {
      'take': '$take',
      'date_to': today,
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
        final List<dynamic> data = decoded is List
            ? decoded
            : (decoded['data'] as List<dynamic>? ?? []);
        return data
            .map((e) => Events.fromMap(e as Map<String, dynamic>))
            .toList();
      } else {
        return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
      }
    } catch (e, s) {
      log(
        'EventsRepository: Erro ao buscar eventos recentes',
        error: e.toString(),
        stackTrace: s,
      );
      return Future.error('Erro ao buscar eventos recentes');
    }
  }
}
