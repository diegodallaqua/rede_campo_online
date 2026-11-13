import '../global/constants/api_constants.dart';
import '../network/api_client.dart';
import '../models/research_areas.dart';

class ResearchAreasRepository {
  final _api = const ApiClient();

  Future<List<ResearchAreas>> findAll() => _api.getList(
        researchAreasURL,
        ResearchAreas.fromMap,
        query: {'take': 100},
        errorMessage: 'Erro ao buscar Áreas de Pesquisa',
      );
}
