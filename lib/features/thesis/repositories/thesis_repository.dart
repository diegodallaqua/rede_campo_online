import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/repositories/token_repository.dart';
import '../../../core/stores/filter_search_store.dart';
import '../models/thesis.dart';

class ThesisRepository {
  Future<void> createThesis(Thesis thesis) async {
    var url = Uri.parse(baseURL + thesisURL);
    final token = await TokenRepository().getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(thesis.toMap()),
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
      log('Repository: Erro ao criar Dissertação.',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao criar Dissertação');
    }
  }

  Future<List<Thesis>> findAllThesis(
      {int? page, FilterSearchStore? filterSearchStore, int? take}) async {
    final token = await TokenRepository().getToken();

    final url = Uri.parse('$baseURL$thesisURL').replace(queryParameters: {
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
        final List<Thesis> theses = data.map((t) => Thesis.fromMap(t)).toList();
        return theses;
      } else {
        return Future.error(
          ErrorsAPI.fromMap(
            json.decode(response.body),
          ),
        );
      }
    } catch (e, s) {
      log('Repository: Erro ao buscar Dissertaçãos:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar Dissertaçãos');
    }
  }

  /// Busca a tese de uma publicação específica. Retorna null se a publicação
  /// não for uma tese (ou não houver registro).
  Future<Thesis?> findByPublicationId(int publicationId) async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$thesisURL$publicationId');

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
        return Thesis.fromMap(map as Map<String, dynamic>);
      }
      return null;
    } catch (e, s) {
      log('Repository: Erro ao buscar Tese por publicação:',
          error: e.toString(), stackTrace: s);
      return null;
    }
  }

  Future<void> editThesis(Thesis thesis) async {
    var url =
        Uri.parse(baseURL + thesisURL + thesis.publication!.id!.toString());

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
        body: jsonEncode(thesis.toMap()..remove('publication_id')),
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
      log('Repository: Erro ao editar Dissertação:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao editar Dissertação');
    }
  }

  Future<void> deleteThesis(String id) async {
    var url = Uri.parse(baseURL + thesisURL + id);

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
      log('Repository: Erro ao deletar Dissertação:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao deletar Dissertação');
    }
  }
}
