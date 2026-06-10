import 'package:get_it/get_it.dart';

import '../../features/admin/publications/stores/admin_create_publication_store.dart';
import '../../features/admin/stores/admin_store.dart';
import '../../features/login/stores/login_store.dart';
import '../utils/stores/user_manager_store.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<UserManagerStore>(() => UserManagerStore());
  getIt.registerLazySingleton<LoginStore>(() => LoginStore());
  getIt.registerLazySingleton<AdminStore>(() => AdminStore());
  getIt.registerLazySingleton<AdminCreatePublicationStore>(
      () => AdminCreatePublicationStore());
}
