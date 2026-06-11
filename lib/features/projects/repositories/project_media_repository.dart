import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/utils/repositories/token_repository.dart';
import '../models/project_media.dart';

class ProjectMediaRepository {
  /// Tenta extrair a mensagem de erro JSON da resposta; se o corpo não for
  /// JSON (ex.: página HTML de erro 404/500), devolve uma mensagem legível
  /// com o status HTTP em vez de estourar um FormatException.
  Object _parseError(http.Response response, String fallback) {
    try {
      return ErrorsAPI.fromMap(
          json.decode(response.body) as Map<String, dynamic>);
    } catch (_) {
      return '$fallback (HTTP ${response.statusCode})';
    }
  }

  Future<ProjectMedia> create(ProjectMedia media) async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$projectMediaURL');

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
        return ProjectMedia.fromMap(
            jsonDecode(response.body) as Map<String, dynamic>);
      }
      return Future.error(
          _parseError(response, 'Erro ao salvar imagem do projeto'));
    } catch (e, s) {
      log('ProjectMediaRepository: erro ao criar ProjectMedia',
          error: e.toString(), stackTrace: s);
      return Future.error(e is String ? e : 'Erro ao salvar imagem do projeto');
    }
  }

  Future<List<ProjectMedia>> findByProjectId(int projectId) async {
    final all = await findAll();
    return all.where((m) => m.project?.id == projectId).toList();
  }

  Future<void> deleteMedia(int id) async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$projectMediaURL$id');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('DELETE $url -> ${response.statusCode} ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) return;

      return Future.error(
          _parseError(response, 'Erro ao remover imagem do projeto'));
    } catch (e, s) {
      log('ProjectMediaRepository: erro ao deletar ProjectMedia',
          error: e.toString(), stackTrace: s);
      return Future.error(
          e is String ? e : 'Erro ao remover imagem do projeto');
    }
  }

  Future<List<ProjectMedia>> findAll() async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$projectMediaURL?take=100');

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
            .map((m) => ProjectMedia.fromMap(m as Map<String, dynamic>))
            .toList();
      } else {
        return Future.error(
            _parseError(response, 'Erro ao buscar imagens dos projetos'));
      }
    } catch (e, s) {
      log('ProjectMediaRepository: Erro ao buscar ProjectMedia:',
          error: e.toString(), stackTrace: s);
      return Future.error(
          e is String ? e : 'Erro ao buscar imagens dos projetos');
    }
  }
}
