import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/utils/repositories/token_repository.dart';
import '../models/news_media.dart';

class NewsMediaRepository {
  Future<NewsMedia> create(NewsMedia media) async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$newsMediaURL');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(media.toMap()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NewsMedia.fromMap(
            jsonDecode(response.body) as Map<String, dynamic>);
      }
      return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
    } catch (e, s) {
      log('NewsMediaRepository: erro ao criar NewsMedia',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao salvar imagem da notícia');
    }
  }

  Future<List<NewsMedia>> findByNewsId(int newsId) async {
    final all = await findAll();
    return all.where((m) => m.news?.id == newsId).toList();
  }

  Future<void> deleteMedia(int id) async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$newsMediaURL/$id');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
      }
    } catch (e, s) {
      log('NewsMediaRepository: erro ao deletar NewsMedia',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao remover imagem da notícia');
    }
  }

  Future<List<NewsMedia>> findAll() async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$newsMediaURL');

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

        List<dynamic> data;
        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map && decoded.containsKey('data')) {
          data = decoded['data'] as List<dynamic>;
        } else {
          return [];
        }

        return data
            .map((m) => NewsMedia.fromMap(m as Map<String, dynamic>))
            .toList();
      } else {
        return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
      }
    } catch (e, s) {
      log('NewsMediaRepository: Erro ao buscar NewsMedia:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar imagens das notícias');
    }
  }
}
