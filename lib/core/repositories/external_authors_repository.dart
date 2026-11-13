import '../global/constants/api_constants.dart';
import '../network/api_client.dart';
import '../models/external_author.dart';

class ExternalAuthorsRepository {
  final _api = const ApiClient();

  Future<ExternalAuthors> create(ExternalAuthors externalAuthor) async {
    const error = 'Erro ao criar Autor Externo';
    final map = await _api.post(
      externalAuthorsURL,
      externalAuthor.toMap(),
      errorMessage: error,
    );
    if (map == null) throw error;
    return ExternalAuthors.fromMap(map);
  }
}
