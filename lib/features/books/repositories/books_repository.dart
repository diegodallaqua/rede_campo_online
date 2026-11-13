import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/repositories/token_repository.dart';
import '../../../core/stores/filter_search_store.dart';
import '../models/books.dart';

class BooksRepository {
  Future<void> createBooks(Books book) async {
    var url = Uri.parse(baseURL + booksURL);
    final token = await TokenRepository().getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(book.toMap()),
      );

      if (response.statusCode != 200 &&
          response.statusCode != 204 &&
          response.statusCode != 201) {
        return Future.error(
          ErrorsAPI.fromMap(
            json.decode(response.body),
          ),
        );
      }
    } catch (e, s) {
      log('Repository: Erro ao criar Livro.',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao criar Livro');
    }
  }

  Future<List<Books>> findAllBooks(
      {int? page, FilterSearchStore? filterSearchStore, int? take}) async {
    final token = await TokenRepository().getToken();

    final url = Uri.parse('$baseURL$booksURL').replace(queryParameters: {
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
        final List<Books> books = data.map((a) => Books.fromMap(a)).toList();
        return books;
      } else {
        return Future.error(
          ErrorsAPI.fromMap(
            json.decode(response.body),
          ),
        );
      }
    } catch (e, s) {
      log('Repository: Erro ao buscar Livros:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar Livros');
    }
  }

  /// Livro da publicação, ou null se não houver.
  Future<Books?> findByPublicationId(int publicationId) async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$booksURL$publicationId');

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
        return Books.fromMap(map as Map<String, dynamic>);
      }
      return null;
    } catch (e, s) {
      log('Repository: Erro ao buscar Livro por publicação:',
          error: e.toString(), stackTrace: s);
      return null;
    }
  }

  Future<void> editBooks(Books book) async {
    var url = Uri.parse(baseURL + booksURL + book.publication!.id!.toString());

    final token = await TokenRepository().getToken();

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // Id vai na URL; a API o rejeita no corpo do PUT.
        body: jsonEncode(book.toMap()..remove('publication_id')),
      );

      if (response.statusCode != 200 &&
          response.statusCode != 204 &&
          response.statusCode != 201) {
        return Future.error(
          ErrorsAPI.fromMap(
            json.decode(response.body),
          ),
        );
      }
    } catch (e, s) {
      log('Repository: Erro ao editar Livro:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao editar Livro');
    }
  }

  Future<void> deleteBook(String id) async {
    var url = Uri.parse(baseURL + booksURL + id);

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
        return Future.error(
          ErrorsAPI.fromMap(
            json.decode(response.body),
          ),
        );
      }
    } catch (e, s) {
      log('Repository: Erro ao deletar Livro:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao deletar Livro');
    }
  }
}
