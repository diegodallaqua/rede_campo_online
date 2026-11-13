import 'dart:developer';

import '../../../core/network/api_client.dart';

/// CRUD comum dos registros de tipo de publicação (artigo, livro, capítulo
/// e trabalho acadêmico), todos identificados pelo `publication_id`.
abstract class PublicationTypeRepository<T> {
  const PublicationTypeRepository();

  final _api = const ApiClient();

  /// Rota da API (ex.: `articlesURL`).
  String get path;

  /// Nome no singular e no plural, usado nas mensagens de erro.
  String get singular;
  String get plural;

  T fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap(T item);
  int? publicationIdOf(T item);

  Future<void> create(T item) =>
      _api.post(path, toMap(item), errorMessage: 'Erro ao criar $singular');

  Future<List<T>> findAll({int? page, String? search, int? take}) =>
      _api.getList(
        path,
        fromMap,
        query: {
          'page': page,
          'take': take,
          if (search != null && search.isNotEmpty) 'search': search,
        },
        errorMessage: 'Erro ao buscar $plural',
      );

  /// Registro da publicação, ou null se ela não for deste tipo.
  Future<T?> findByPublicationId(int publicationId) async {
    try {
      final map = await _api.getOne('$path$publicationId',
          errorMessage: 'Erro ao buscar $singular');
      return map == null ? null : fromMap(map);
    } catch (e, s) {
      log('$runtimeType: $singular da publicação $publicationId indisponível',
          error: e, stackTrace: s);
      return null;
    }
  }

  // Id vai na URL; a API o rejeita no corpo do PUT.
  Future<void> edit(T item) => _api.put(
        '$path${publicationIdOf(item)}',
        toMap(item)..remove('publication_id'),
        errorMessage: 'Erro ao editar $singular',
      );
}
