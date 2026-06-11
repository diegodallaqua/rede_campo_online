import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/utils/repositories/token_repository.dart';
import '../../../core/utils/stores/filter_search_store.dart';
import '../models/publications.dart';

class PublicationsRepository {
  Future<Publications> createPublication(Publications publication) async {
    var url = Uri.parse(baseURL + publicationsURL);
    final token = await TokenRepository().getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(publication.toMap()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final map = decoded is Map<String, dynamic>
            ? (decoded.containsKey('data')
                ? decoded['data'] as Map<String, dynamic>
                : decoded)
            : decoded as Map<String, dynamic>;
        return Publications.fromMap(map);
      }
      if (response.statusCode == 204) {
        return Publications();
      }
      return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
    } catch (e, s) {
      log('Repository: Erro ao criar Publicação.',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao criar Publicação');
    }
  }

  Future<List<Publications>> findAllPublications(
      {int? page = 1, FilterSearchStore? filterSearchStore, int? take}) async {
    final token = await TokenRepository().getToken();

    final url = Uri.parse('$baseURL$publicationsURL').replace(queryParameters: {
      'page': '$page',
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
        final List<Publications> publications =
            data.map((p) => Publications.fromMap(p)).toList();
        return publications;
      } else {
        return Future.error(
          ErrorsAPI.fromMap(
            json.decode(response.body),
          ),
        );
      }
    } catch (e, s) {
      log('Repository: Erro ao buscar Publicações:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar Publicações');
    }
  }

  Future<void> editPublication(Publications publication) async {
    var url = Uri.parse(baseURL + publicationsURL + publication.id!.toString());

    final token = await TokenRepository().getToken();

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(publication.toMap()),
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
      log('Repository: Erro ao editar Publicação:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao editar Publicação');
    }
  }

  Future<void> deletePublication(String id) async {
    var url = Uri.parse(baseURL + publicationsURL + id);

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
      log('Repository: Erro ao deletar Publicação:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao deletar Publicação');
    }
  }
}
