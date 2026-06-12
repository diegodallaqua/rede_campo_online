import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../core/stores/base_store.dart';
import '../models/members.dart';
import '../repositories/members_repository.dart';

part 'members_store.g.dart';

class MembersStore = MembersStoreBase with _$MembersStore;

abstract class MembersStoreBase extends BaseStore<Members> with Store {
  final MembersRepository _repository = MembersRepository();

  MembersStoreBase() {
    loadMembers();
  }

  @observable
  bool isLoading = false;

  @observable
  String? membersError;

  @computed
  bool get showProgress => isLoading && list.isEmpty;

  @action
  Future<void> loadMembers() async {
    if (isLoading) return;
    isLoading = true;
    membersError = null;

    try {
      final result = await _repository.findAllMembers(page: 1);
      setData(result);
    } catch (e, s) {
      log('MembersStore: Erro ao carregar Membros',
          error: e.toString(), stackTrace: s);
      membersError = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> refreshMembers() async {
    setData([]);
    await loadMembers();
  }
}
