import 'package:mobx/mobx.dart';

import '../models/auth_token.dart';
import '../repositories/token_repository.dart';

part 'user_manager_store.g.dart';

class UserManagerStore = UserManagerStoreBase with _$UserManagerStore;

abstract class UserManagerStoreBase with Store {
  final _tokenRepository = TokenRepository();

  @readonly
  AuthResponse? _authData;

  @readonly
  bool _loading = false;

  @readonly
  String? _errorMessage;

  /// True enquanto o usuário possui sessão ativa com token válido.
  @computed
  bool get isLoggedIn => _authData != null;

  /// Atalhos de conveniência para a UI responsiva.
  @computed
  String get userName => _authData?.user?.name ?? '';

  @computed
  String get userEmail => _authData?.user?.email ?? '';

  @computed
  String get roleName => _authData?.user?.memberRole?.name ?? '';

  @computed
  String get organizationName => _authData?.user?.organization?.name ?? '';

  @action
  void setLoading(bool value) => _loading = value;

  @action
  void setError(String? message) => _errorMessage = message;


  /// Realiza o login e persiste o token.
  @action
  Future<bool> login(String email, String password) async {
    setLoading(true);
    _errorMessage = null;

    try {
      final result = await _tokenRepository.loginAPI(email, password);

      if (result != null) {
        _authData = result;
        setLoading(false);
        return true;
      }
    } catch (e) {
      setError('E-mail ou senha inválidos.');
    } finally {
      setLoading(false);
    }
    return false;
  }

  /// Verifica se há um token válido salvo (para auto-login na inicialização).
  @action
  Future<bool> checkSession() async {
    setLoading(true);

    bool valid = false;

    try {
      valid = await _tokenRepository.verifyToken();
    } catch (e) {
      setError('Erro ao recuperar Token de Login.');
    } finally {
      setLoading(false);
    }

    return valid;
  }

  /// Realiza o logout limpando estado e storage.
  @action
  Future<void> logout() async {
    setLoading(true);
    await _tokenRepository.exit();

    // Garante que nenhum dado sensível permaneça em memória após o logout.
    _authData = null;
    setError(null);
    setLoading(false);
  }

  @action
  void clearError() => _errorMessage = null;

}