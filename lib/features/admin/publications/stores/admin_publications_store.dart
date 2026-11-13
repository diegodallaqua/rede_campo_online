import '../../../../core/stores/paged_store.dart';
import '../../../publications/models/publications.dart';
import '../../../publications/repositories/publications_repository.dart';

class AdminPublicationsStore extends PagedStore<Publications> {
  AdminPublicationsStore({super.pageSize});

  final _repository = PublicationsRepository();

  @override
  Future<List<Publications>> fetchPage(int page) =>
      _repository.findAllPublications(
        page: page,
        search: filterStore.search,
        take: pageSize,
      );
}
