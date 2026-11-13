import '../../../core/global/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/events.dart';

class EventsRepository {
  final _api = const ApiClient();

  Future<Events> createEvent(Events event) async {
    final map = await _api.post(eventsURL, event.toMap(),
        errorMessage: 'Erro ao criar Evento');
    return map == null ? Events() : Events.fromMap(map);
  }

  Future<List<Events>> findAllEvents(
          {int? page = 1, String? search, int take = 15}) =>
      _find(
        {
          'page': page,
          'take': take,
          if (search != null && search.isNotEmpty) 'search': search,
        },
        'Erro ao buscar Eventos',
      );

  Future<void> editEvent(Events event) =>
      _api.put('$eventsURL${event.id}', event.toMap(),
          errorMessage: 'Erro ao editar Evento');

  Future<void> deleteEvent(String id) =>
      _api.delete('$eventsURL$id', errorMessage: 'Erro ao deletar Evento');

  Future<List<Events>> findByProjectId(int projectId) =>
      _find({'project_id': projectId}, 'Erro ao buscar eventos do projeto');

  Future<List<Events>> findUpcomingEvents({int page = 1, int take = 4}) =>
      _find({'page': page, 'take': take, 'date_from': _today()},
          'Erro ao buscar próximos eventos');

  Future<List<Events>> findRecentEvents({int take = 4}) => _find(
      {'take': take, 'date_to': _today()}, 'Erro ao buscar eventos recentes');

  Future<List<Events>> _find(Map<String, Object?> query, String errorMessage) =>
      _api.getList(eventsURL, Events.fromMap,
          query: query, errorMessage: errorMessage);

  static String _today() => DateTime.now().toIso8601String().substring(0, 10);
}
