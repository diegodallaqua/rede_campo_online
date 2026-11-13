import '../global/constants/api_constants.dart';
import '../network/api_client.dart';
import '../models/contributor.dart';

class ContributorsRepository {
  final _api = const ApiClient();

  Future<void> create(Contributors contributor) => _api.post(
        contributorsURL,
        contributor.toMap(),
        errorMessage: 'Erro ao criar Contribuidor',
      );

  // Sem id próprio: identificado por (publication_id, author_order) na rota.
  Future<void> delete(int publicationId, int authorOrder) => _api.delete(
        '$contributorsURL$publicationId/$authorOrder',
        errorMessage: 'Erro ao remover Contribuidor',
      );
}
