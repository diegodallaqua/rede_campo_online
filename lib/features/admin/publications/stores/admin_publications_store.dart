import '../../../../core/stores/paged_store.dart';
import '../../../publications/models/publications.dart';
import '../../../publications/repositories/publications_repository.dart';

class AdminPublicationsStore extends PagedStore<Publications> {
  final PublicationsRepository _repository = PublicationsRepository();

  AdminPublicationsStore({super.pageSize});

  @override
  Future<List<Publications>> fetchPage(int page) =>
      _repository.findAllPublications(
        page: page,
        filterSearchStore: filterStore,
        take: pageSize,
      );
}
