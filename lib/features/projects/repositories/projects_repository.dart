import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../core/global/constants/api_constants.dart';
import '../../../core/utils/error_message_api.dart';
import '../../../core/utils/repositories/token_repository.dart';
import '../../../core/utils/stores/filter_search_store.dart';
import '../models/projects.dart';

class ProjectsRepository {
  Future<Projects> createProject(Projects projects) async {
    var url = Uri.parse(baseURL + projectsURL);
    final token = await TokenRepository().getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(projects.toMap()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final map = decoded is Map<String, dynamic>
            ? (decoded.containsKey('data')
                ? decoded['data'] as Map<String, dynamic>
                : decoded)
            : decoded as Map<String, dynamic>;
        return Projects.fromMap(map);
      }
      if (response.statusCode == 204) {
        return Projects();
      }
      return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
    } catch (e, s) {
      log('Repository: Erro ao criar Projeto.',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao criar Projeto');
    }
  }

  Future<List<Projects>> findAllProjects(
      {int? page = 1,
      FilterSearchStore? filterSearchStore,
      int take = 3}) async {
    final token = await TokenRepository().getToken();

    final url = Uri.parse('$baseURL$projectsURL').replace(queryParameters: {
      'page': '$page',
      'take': '$take',
      if (filterSearchStore != null && filterSearchStore.search.isNotEmpty)
        'project_name': filterSearchStore.search,
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
        final List<Projects> projects =
            data.map((p) => Projects.fromMap(p)).toList();
        return projects;
      } else {
        return Future.error(
          ErrorsAPI.fromMap(
            json.decode(response.body),
          ),
        );
      }
    } catch (e, s) {
      log('Repository: Erro ao buscar Projetos:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar Projetos');
    }
  }

  Future<void> editProject(Projects projects) async {
    var url = Uri.parse(baseURL + projectsURL + projects.id!.toString());

    final token = await TokenRepository().getToken();

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(projects.toMap()),
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
      log('Repository: Erro ao editar Projeto:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao editar Projeto');
    }
  }

  Future<void> deleteProject(String id) async {
    var url = Uri.parse(baseURL + projectsURL + id);

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
      log('Repository: Erro ao deletar Projeto:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao deletar Projeto');
    }
  }
}
