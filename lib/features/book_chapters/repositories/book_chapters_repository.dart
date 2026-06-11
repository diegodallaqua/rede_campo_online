import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/utils/repositories/token_repository.dart';
import '../../../core/utils/stores/filter_search_store.dart';
import '../models/book_chapters.dart';

class BookChaptersRepository {
  Future<void> createBookChapters(BookChapters bookChapters) async {
    var url = Uri.parse(baseURL + bookChaptersURL);
    final token = await TokenRepository().getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(bookChapters.toMap()),
      );

      if (response.statusCode != 200 &&
          response.statusCode != 204 &&
          response.statusCode != 201) {
        // 200	OK
        // 204	No Content
        // 201  Created
        return Future.error(
          ErrorsAPI.fromMap(
            json.decode(response.body),
          ),
        );
      }
    } catch (e, s) {
      log('Repository: Erro ao criar Capítulo de Livro.',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao criar Capítulo de Livro');
    }
  }

  Future<List<BookChapters>> findAllBookChapters(
      {int? page,
      FilterSearchStore? filterSearchStore,
      int? take}) async {
    final token = await TokenRepository().getToken();

    final url = Uri.parse('$baseURL$bookChaptersURL').replace(queryParameters: {
      if (page != null) 'page': '$page',
      if (take != null) 'take': '$take',
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
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final List<dynamic> data = jsonData["data"];
        final List<BookChapters> bookChapters =
            data.map((a) => BookChapters.fromMap(a)).toList();
        return bookChapters;
      } else {
        return Future.error(
          ErrorsAPI.fromMap(
            json.decode(response.body),
          ),
        );
      }
    } catch (e, s) {
      log('Repository: Erro ao buscar Capítulos de Livro:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar Capítulos de Livro');
    }
  }

  /// Busca o capítulo de uma publicação específica. Retorna null se a
  /// publicação não for um capítulo de livro (ou não houver registro).
  Future<BookChapters?> findByPublicationId(int publicationId) async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$bookChaptersURL$publicationId');

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
        final map = decoded is Map<String, dynamic>
            ? (decoded.containsKey('data') ? decoded['data'] : decoded)
            : decoded;
        if (map == null) return null;
        return BookChapters.fromMap(map as Map<String, dynamic>);
      }
      return null;
    } catch (e, s) {
      log('Repository: Erro ao buscar Capítulo por publicação:',
          error: e.toString(), stackTrace: s);
      return null;
    }
  }

  Future<void> editBookChapters(BookChapters bookChapters) async {
    var url = Uri.parse(
        baseURL + bookChaptersURL + bookChapters.publication!.id!.toString());

    final token = await TokenRepository().getToken();

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // O id da publicação já vai na URL; a API rejeita-o no corpo do PUT.
        body: jsonEncode(bookChapters.toMap()..remove('publication_id')),
      );

      if (response.statusCode != 200 &&
          response.statusCode != 204 &&
          response.statusCode != 201) {
        // 200	OK
        // 204	No Content
        // 201  Created
        return Future.error(
          ErrorsAPI.fromMap(
            json.decode(response.body),
          ),
        );
      }
    } catch (e, s) {
      log('Repository: Erro ao editar Capítulo de Livro:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao editar Capítulo de Livro');
    }
  }

  Future<void> deleteBookChapter(String id) async {
    var url = Uri.parse(baseURL + bookChaptersURL + id);

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
        // 200	OK
        // 204	No Content
        return Future.error(
          ErrorsAPI.fromMap(
            json.decode(response.body),
          ),
        );
      }
    } catch (e, s) {
      log('Repository: Erro ao deletar Capítulo de Livro:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao deletar Capítulo de Livro');
    }
  }
}
