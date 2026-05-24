import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/utils/repositories/token_repository.dart';
import '../../../core/utils/stores/filter_search_store.dart';
import '../models/technical_reports.dart';

class TechnicalReportsRepository {
  Future<void> createTechnicalReport(TechnicalReports TechnicalReport) async {
    var url = Uri.parse(baseURL + technicalReportsURL);
    final token = await TokenRepository().getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(TechnicalReport.toMap()),
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
      log('Repository: Erro ao criar Relatório.',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao criar Relatório');
    }
  }

  Future<List<TechnicalReports>> findAllTechnicalReports(
      {int? page, FilterSearchStore? filterSearchStore, int? take}) async {
    final token = await TokenRepository().getToken();

    final url =
        Uri.parse('$baseURL$technicalReportsURL').replace(queryParameters: {
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
        final List<TechnicalReports> technicalReports =
            data.map((t) => TechnicalReports.fromMap(t)).toList();
        return technicalReports;
      } else {
        return Future.error(
          ErrorsAPI.fromMap(
            json.decode(response.body),
          ),
        );
      }
    } catch (e, s) {
      log('Repository: Erro ao buscar Relatórios:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar Relatórios');
    }
  }

  Future<void> editTechnicalReports(TechnicalReports technicalReport) async {
    var url = Uri.parse(baseURL +
        technicalReportsURL +
        technicalReport.publication!.id!.toString());

    final token = await TokenRepository().getToken();

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(technicalReport.toMap()),
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
      log('Repository: Erro ao editar Relatório:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao editar Relatório');
    }
  }

  Future<void> deleteTechnicalReport(String id) async {
    var url = Uri.parse(baseURL + technicalReportsURL + id);

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
      log('Repository: Erro ao deletar Relatório:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao deletar Relatório');
    }
  }
}
