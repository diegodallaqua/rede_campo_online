import '../../../core/global/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/publications.dart';

class PublicationsRepository {
  final _api = const ApiClient();

  Future<Publications> createPublication(Publications publication) async {
    final map = await _api.post(publicationsURL, publication.toMap(),
        errorMessage: 'Erro ao criar Publicação');
    return map == null ? Publications() : Publications.fromMap(map);
  }

  Future<List<Publications>> findAllPublications(
          {int? page = 1, String? search, int? take}) =>
      _api.getList(
        publicationsURL,
        Publications.fromMap,
        query: {
          'page': page,
          'take': take,
          if (search != null && search.isNotEmpty) 'search': search,
        },
        errorMessage: 'Erro ao buscar Publicações',
      );

  Future<List<Publications>> findByProjectId(int projectId) => _api.getList(
        '$projectsURL$projectId/publications',
        Publications.fromMap,
        errorMessage: 'Erro ao buscar publicações do projeto',
      );

  Future<void> editPublication(Publications publication) =>
      _api.put('$publicationsURL${publication.id}', publication.toMap(),
          errorMessage: 'Erro ao editar Publicação');

  Future<void> deletePublication(String id) =>
      _api.delete('$publicationsURL$id',
          errorMessage: 'Erro ao deletar Publicação');
}
