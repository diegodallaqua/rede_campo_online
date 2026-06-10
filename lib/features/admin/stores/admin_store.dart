import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/core/global/injection.dart';
import 'package:rede_campo_online/core/utils/stores/user_manager_store.dart';

part 'admin_store.g.dart';

class AdminStore = AdminStoreBase with _$AdminStore;

abstract class AdminStoreBase with Store {
  final _userStore = getIt<UserManagerStore>();

  @computed
  String get userName => _userStore.userName;

  @computed
  String get userEmail => _userStore.userEmail;

  @computed
  String get roleName => _userStore.roleName;

  @computed
  String get organizationName => _userStore.organizationName;

  @action
  Future<void> logout() => _userStore.logout();
}
