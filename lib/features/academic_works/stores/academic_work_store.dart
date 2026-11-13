import '../../../core/stores/client_paged_store.dart';
import '../models/academic_work.dart';
import '../repositories/academic_work_repository.dart';

class AcademicWorkStore extends ClientPagedStore<AcademicWork> {
  AcademicWorkStore({super.pageSize = 15});

  final _repository = const AcademicWorkRepository();

  @override
  Future<List<AcademicWork>> fetchAll() => _repository.findAll();

  @override
  bool matches(AcademicWork item, String query) =>
      (item.publication?.title ?? '').toLowerCase().contains(query);
}
