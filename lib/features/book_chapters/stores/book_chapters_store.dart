import '../../../core/stores/client_paged_store.dart';
import '../models/book_chapters.dart';
import '../repositories/book_chapters_repository.dart';

class BookChaptersStore extends ClientPagedStore<BookChapters> {
  BookChaptersStore({super.pageSize = 15});

  final _repository = const BookChaptersRepository();

  @override
  Future<List<BookChapters>> fetchAll() => _repository.findAll();

  @override
  bool matches(BookChapters item, String query) =>
      (item.publication?.title ?? '').toLowerCase().contains(query) ||
      (item.displayBookName ?? '').toLowerCase().contains(query);
}
