import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/utils/repositories/token_repository.dart';
import '../../../core/utils/stores/filter_search_store.dart';
import '../models/news.dart';

class NewsRepository {
  Future<void> createNews(News news) async {
    var url = Uri.parse(baseURL + newsURL);
    final token = await TokenRepository().getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(news.toMap()),
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
      log('Repository: Erro ao criar Notícia.',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao criar Notícia');
    }
  }

  Future<List<News>> findAllNews(
      {int? page = 1, FilterSearchStore? filterSearchStore}) async {
    final token = await TokenRepository().getToken();

    final url = Uri.parse('$baseURL$newsURL').replace(queryParameters: {
      'page': '$page',
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
        final List<News> news = data.map((n) => News.fromMap(n)).toList();
        return news;
      } else {
        return Future.error(
          ErrorsAPI.fromMap(
            json.decode(response.body),
          ),
        );
      }
    } catch (e, s) {
      log('Repository: Erro ao buscar Notícias:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar Notícias');
    }
  }

  Future<void> editNews(News news) async {
    var url = Uri.parse(baseURL + newsURL + news.id!.toString());

    final token = await TokenRepository().getToken();

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(news.toMap()),
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
      log('Repository: Erro ao editar Notícia:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao editar Notícia');
    }
  }

  Future<void> deleteNews(String id) async {
    var url = Uri.parse(baseURL + newsURL + id);

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
      log('Repository: Erro ao deletar Notícia:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao deletar Notícia');
    }
  }
}
