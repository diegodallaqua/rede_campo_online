import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../core/global/constants/api_constants.dart';
import '../../core/utils/error_message_api.dart';
import '../../core/repositories/token_repository.dart';
import '../models/contributor.dart';

class ContributorsRepository {
  Future<void> create(Contributors contributor) async {
    var url = Uri.parse(baseURL + contributorsURL);
    final token = await TokenRepository().getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(contributor.toMap()),
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
      log('Repository: Erro ao criar Contribuidor.',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao criar Contribuidor');
    }
  }

  Future<void> delete(int id) async {
    var url = Uri.parse('$baseURL$contributorsURL$id');
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
      log('Repository: Erro ao remover Contribuidor.',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao remover Contribuidor');
    }
  }
}
