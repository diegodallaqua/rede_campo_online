import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/core/global/injection.dart';
import 'package:rede_campo_online/core/utils/stores/user_manager_store.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  final _userStore = getIt<UserManagerStore>();

  @readonly
  bool _obscurePassword = true;

  @computed
  bool get loading => _userStore.loading;

  @computed
  String? get errorMessage => _userStore.errorMessage;

  @action
  void togglePasswordVisibility() => _obscurePassword = !_obscurePassword;

  @action
  void clearError() => _userStore.clearError();

  @action
  Future<bool> submit(String email, String password) {
    _userStore.clearError();
    return _userStore.login(email.trim().toLowerCase(), password);
  }
}
