import 'package:get_it/get_it.dart';

import '../utils/stores/user_manager_store.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Ordem importa: UserManagerStore antes do LoginStore.
  getIt.registerLazySingleton<UserManagerStore>(() => UserManagerStore());
}
