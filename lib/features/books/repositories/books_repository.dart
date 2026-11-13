import '../../../core/global/constants/api_constants.dart';
import '../../publications/repositories/publication_type_repository.dart';
import '../models/books.dart';

class BooksRepository extends PublicationTypeRepository<Books> {
  const BooksRepository();

  @override
  String get path => booksURL;

  @override
  String get singular => 'Livro';

  @override
  String get plural => 'Livros';

  @override
  Books fromMap(Map<String, dynamic> map) => Books.fromMap(map);

  @override
  Map<String, dynamic> toMap(Books item) => item.toMap();

  @override
  int? publicationIdOf(Books item) => item.publication?.id;
}
