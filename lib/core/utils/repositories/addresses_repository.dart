import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../global/constants/api_constants.dart';
import '../error_message_api.dart';
import '../models/addresses.dart';
import 'token_repository.dart';

class AddressesRepository {
  Future<List<Addresses>> findAll() async {
    final token = await TokenRepository().getToken();
    final url = Uri.parse('$baseURL$addressesURL')
        .replace(queryParameters: {'take': '100'});

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
        final List<dynamic> data = decoded is List
            ? decoded
            : (decoded['data'] as List<dynamic>? ?? []);
        return data
            .map((a) => Addresses.fromMap(a as Map<String, dynamic>))
            .toList();
      } else {
        return Future.error(ErrorsAPI.fromMap(json.decode(response.body)));
      }
    } catch (e, s) {
      log('AddressesRepository: Erro ao buscar Endereços:',
          error: e.toString(), stackTrace: s);
      return Future.error('Erro ao buscar Endereços');
    }
  }
}
