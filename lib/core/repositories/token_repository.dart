import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../global/constants/api_constants.dart' show baseURL, loginURL;
import '../models/auth_token.dart';

class TokenRepository {
  static const _storage = FlutterSecureStorage(
    webOptions: WebOptions(dbName: 'rede_campo_vault', publicKey: ''),
  );

  static const _keyToken = 'jwt_token';
  static const _keyTokenTimestamp = 'jwt_timestamp';
  static const _keyAuthData = 'jwt_auth_data';

  /// Realiza o login na API e armazena o token de forma segura.
  Future<AuthResponse?> loginAPI(String email, String password) async {
    final url = Uri.parse(baseURL + loginURL);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final authData = AuthResponse.fromMap(body);

        await _storage.write(key: _keyToken, value: authData.token);
        await _storage.write(
          key: _keyTokenTimestamp,
          value: DateTime.now().toIso8601String(),
        );
        await _storage.write(
          key: _keyAuthData,
          value: json.encode(authData.toMap()),
        );

        return authData;
      }

      return null;
    } catch (e) {
      log('Erro ao realizar login', error: e);
      return null;
    }
  }

  /// Recupera o token armazenado.
  Future<String> getToken() async {
    return await _storage.read(key: _keyToken) ?? '';
  }

  /// Restaura o AuthResponse persistido após login.
  Future<AuthResponse?> getStoredAuthData() async {
    final raw = await _storage.read(key: _keyAuthData);
    if (raw == null || raw.isEmpty) return null;
    try {
      return AuthResponse.fromMap(json.decode(raw) as Map<String, dynamic>);
    } catch (e) {
      log('Erro ao restaurar AuthResponse: $e');
      return null;
    }
  }

  /// Verifica a expiração lendo o `exp` do JWT. A assinatura é validada só
  /// pela API: o segredo nunca deve estar no cliente.
  Future<bool> verifyToken() async {
    final token = await _storage.read(key: _keyToken);
    if (token == null || token.isEmpty) return false;

    try {
      final exp = JWT.decode(token).payload['exp'] as int?;

      if (exp == null) return false;

      final expiresAt =
          DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);

      // Margem de 30s contra race conditions de expiração.
      return DateTime.now().toUtc().isBefore(
            expiresAt.subtract(const Duration(seconds: 30)),
          );
    } catch (e) {
      await exit();
      log('Erro ao recuperar Token de acesso: $e');
      return false;
    }
  }

  /// Limpa todos os dados de autenticação (logout).
  Future<void> exit() async {
    await _storage.deleteAll();
  }
}
