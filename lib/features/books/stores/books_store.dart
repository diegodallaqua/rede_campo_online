import '../../../core/stores/client_paged_store.dart';
import '../models/books.dart';
import '../repositories/books_repository.dart';

class BooksStore extends ClientPagedStore<Books> {
  BooksStore({super.pageSize = 15});

  final _repository = const BooksRepository();

  @override
  Future<List<Books>> fetchAll() => _repository.findAll();

  @override
  bool matches(Books item, String query) =>
      (item.publication?.title ?? '').toLowerCase().contains(query) ||
      (item.publisher ?? '').toLowerCase().contains(query);
}
