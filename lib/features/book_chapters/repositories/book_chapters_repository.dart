import '../../../core/global/constants/api_constants.dart';
import '../../publications/repositories/publication_type_repository.dart';
import '../models/book_chapters.dart';

class BookChaptersRepository extends PublicationTypeRepository<BookChapters> {
  const BookChaptersRepository();

  @override
  String get path => bookChaptersURL;

  @override
  String get singular => 'Capítulo de Livro';

  @override
  String get plural => 'Capítulos de Livro';

  @override
  BookChapters fromMap(Map<String, dynamic> map) => BookChapters.fromMap(map);

  @override
  Map<String, dynamic> toMap(BookChapters item) => item.toMap();

  @override
  int? publicationIdOf(BookChapters item) => item.publication?.id;
}
