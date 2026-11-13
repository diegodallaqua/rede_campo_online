import 'package:mobx/mobx.dart';

import '../../../../core/stores/paged_store.dart';
import '../../../publications/models/publications.dart';
import '../../../publications/repositories/publications_repository.dart';

part 'admin_publications_store.g.dart';

class AdminPublicationsStore = AdminPublicationsStoreBase
    with _$AdminPublicationsStore;

abstract class AdminPublicationsStoreBase extends PagedStore<Publications>
    with Store {
  final PublicationsRepository _repository = PublicationsRepository();

  AdminPublicationsStoreBase({super.pageSize});

  // Estado da listagem como observável próprio (espelha o de BaseStore).
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
  Future<List<Publications>> fetchPage(int page) =>
      _repository.findAllPublications(
        page: page,
        filterSearchStore: filterStore,
        take: pageSize,
      );
}
