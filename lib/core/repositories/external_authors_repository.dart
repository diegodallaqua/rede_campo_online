import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../core/global/constants/api_constants.dart';
import '../../core/utils/error_message_api.dart';
import '../../core/repositories/token_repository.dart';
import '../models/external_author.dart';

class ExternalAuthorsRepository {
  Future<ExternalAuthors> create(ExternalAuthors externalAuthor) async {
    var url = Uri.parse(baseURL + externalAuthorsURL);
    final token = await TokenRepository().getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(externalAuthor.toMap()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final map = decoded is Map<String, dynamic>
            ? (decoded.containsKey('data')
                ? decoded['data'] as Map<String, dynamic>
                : decoded)
            : decoded as Map<String, dynamic>;
        return ExternalAuthors.fromMap(map);
      }

      return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
    } catch (e, s) {
      log('Repository: Erro ao criar Autor Externo.',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao criar Autor Externo');
    }
  }
}
