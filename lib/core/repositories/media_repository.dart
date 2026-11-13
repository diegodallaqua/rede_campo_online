import '../network/api_client.dart';

/// CRUD das imagens vinculadas a uma entidade (notícia, evento, projeto).
abstract class MediaRepository<M> {
  const MediaRepository();

  final _api = const ApiClient();

  /// Rota da API (ex.: `newsMediaURL`).
  String get path;

  /// Complementos das mensagens de erro (ex.: "da notícia", "das notícias").
  String get ofOne;
  String get ofMany;

  M fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap(M media);
  int? ownerIdOf(M media);

  Future<M> create(M media) async {
    final error = 'Erro ao salvar imagem $ofOne';
    final map = await _api.post(path, toMap(media), errorMessage: error);
    if (map == null) throw error;
    return fromMap(map);
  }

  Future<List<M>> findAll() => _api.getList(
        path,
        fromMap,
        query: {'take': 100},
        errorMessage: 'Erro ao buscar imagens $ofMany',
      );

  Future<List<M>> findByOwnerId(int ownerId) async =>
      (await findAll()).where((m) => ownerIdOf(m) == ownerId).toList();

  Future<void> deleteMedia(int id) => _api.delete(
        '$path$id',
        errorMessage: 'Erro ao remover imagem $ofOne',
      );
}
