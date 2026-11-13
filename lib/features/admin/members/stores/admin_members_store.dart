import '../../../../core/stores/paged_store.dart';
import '../../../members/models/members.dart';
import '../../../members/repositories/members_repository.dart';

class AdminMembersStore extends PagedStore<Members> {
  AdminMembersStore({super.pageSize});

  final _repository = MembersRepository();

  @override
  Future<List<Members>> fetchPage(int page) => _repository.findAllMembers(
        page: page,
        search: filterStore.search,
        take: pageSize,
      );
}
