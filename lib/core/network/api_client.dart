import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../global/constants/api_constants.dart';
import '../repositories/token_repository.dart';
import '../utils/error_message_api.dart';

typedef FromMap<T> = T Function(Map<String, dynamic> map);

/// Cliente HTTP da API: monta URL e cabeçalhos, envia o token e padroniza
/// respostas e erros.
///
/// Falha de rede ou resposta ilegível lança [String] com a mensagem
/// informada. Status fora de 2xx lança [ErrorsAPI] quando a API envia uma
/// mensagem, senão a mesma [String].
class ApiClient {
  const ApiClient();

  /// Cabeçalho de autorização, omitido quando não há sessão.
  static Future<Map<String, String>> authHeader() async {
    final token = await TokenRepository().getToken();
    return token.isEmpty ? {} : {'Authorization': 'Bearer $token'};
  }

  /// GET de uma listagem. Aceita lista pura ou envelope `{data: [...]}`.
  Future<List<T>> getList<T>(
    String path,
    FromMap<T> fromMap, {
    Map<String, Object?>? query,
    required String errorMessage,
  }) async {
    final json =
        await _send('GET', path, query: query, errorMessage: errorMessage);
    final items = json is List ? json : (json is Map ? json['data'] : null);
    if (items == null && json is Map) return [];
    if (items is! List) throw errorMessage;
    try {
      return items.map((e) => fromMap(e as Map<String, dynamic>)).toList();
    } catch (e, s) {
      log('ApiClient: resposta inválida em GET $path', error: e, stackTrace: s);
      throw errorMessage;
    }
  }

  /// GET de um registro (desembrulha `{data: {...}}`). Null se vier vazio.
  Future<Map<String, dynamic>?> getOne(
    String path, {
    Map<String, Object?>? query,
    required String errorMessage,
  }) async =>
      _unwrap(
          await _send('GET', path, query: query, errorMessage: errorMessage));

  /// POST; devolve o registro criado, ou null quando a API não o envia.
  Future<Map<String, dynamic>?> post(
    String path,
    Object body, {
    required String errorMessage,
  }) async =>
      _unwrap(
          await _send('POST', path, body: body, errorMessage: errorMessage));

  Future<void> put(String path, Object body, {required String errorMessage}) =>
      _send('PUT', path, body: body, errorMessage: errorMessage);

  Future<void> delete(String path, {required String errorMessage}) =>
      _send('DELETE', path, errorMessage: errorMessage);

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, Object?>? query,
    Object? body,
    required String errorMessage,
  }) async {
    final params = {
      for (final entry in (query ?? const {}).entries)
        if (entry.value != null) entry.key: '${entry.value}',
    };
    final base = Uri.parse('$baseURL$path');
    final uri = params.isEmpty ? base : base.replace(queryParameters: params);

    final http.Response response;
    try {
      final request = http.Request(method, uri)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...await authHeader(),
        });
      if (body != null) request.body = jsonEncode(body);
      response = await http.Response.fromStream(await request.send());
    } catch (e, s) {
      log('ApiClient: falha em $method $path', error: e, stackTrace: s);
      throw errorMessage;
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      log('ApiClient: $method $path respondeu ${response.statusCode}');
      throw _apiError(response.body) ?? errorMessage;
    }
    if (response.body.isEmpty) return null;
    try {
      return jsonDecode(response.body);
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic>? _unwrap(dynamic json) {
    if (json is! Map<String, dynamic>) return null;
    final data = json.containsKey('data') ? json['data'] : json;
    return data is Map<String, dynamic> ? data : null;
  }

  static ErrorsAPI? _apiError(String body) {
    try {
      final json = jsonDecode(body);
      if (json is! Map<String, dynamic>) return null;
      final error = ErrorsAPI.fromMap(json);
      return error.message.isEmpty ? null : error;
    } catch (_) {
      return null;
    }
  }
}
