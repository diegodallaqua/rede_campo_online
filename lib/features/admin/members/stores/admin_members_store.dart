import 'package:mobx/mobx.dart';

import '../../../../core/stores/paged_store.dart';
import '../../../members/models/members.dart';
import '../../../members/repositories/members_repository.dart';

part 'admin_members_store.g.dart';

class AdminMembersStore = AdminMembersStoreBase with _$AdminMembersStore;

abstract class AdminMembersStoreBase extends PagedStore<Members> with Store {
  final MembersRepository _repository = MembersRepository();

  AdminMembersStoreBase({super.pageSize});

  // Estado de carregamento/erro da listagem, exposto como observável próprio
  // do store (espelha o estado herdado de BaseStore via setLoading/setError).
  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @override
  @action
  void setLoading(bool value) {
    super.setLoading(value);
    isLoading = value;
  }

  @override
  @action
  void setError(String? message) {
    super.setError(message);
    errorMessage = message;
  }

  @override
  Future<List<Members>> fetchPage(int page) => _repository.findAllMembers(
        page: page,
        filterSearchStore: filterStore,
        take: pageSize,
      );
}
