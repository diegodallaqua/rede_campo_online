import '../../../core/stores/client_paged_store.dart';
import '../models/articles.dart';
import '../repositories/articles_repository.dart';

class ArticlesStore extends ClientPagedStore<Articles> {
  ArticlesStore({super.pageSize = 15});

  final _repository = const ArticlesRepository();

  @override
  Future<List<Articles>> fetchAll() => _repository.findAll();

  @override
  bool matches(Articles item, String query) =>
      (item.publication?.title ?? '').toLowerCase().contains(query) ||
      (item.journal_name ?? '').toLowerCase().contains(query) ||
      (item.publisher ?? '').toLowerCase().contains(query);
}
