import '../../books/models/books.dart';
import '../../publications/models/publications.dart';

class BookChapters {
  BookChapters({
    this.publication,
    this.book_name,
    this.chapter_number,
    this.book,
    this.isbn,
    this.start_page,
    this.end_page,
  });

  Publications? publication;
  String? book_name;
  num? chapter_number;

  /// Vínculo opcional com um livro já cadastrado no sistema.
  Books? book;
  String? isbn;
  int? start_page;
  int? end_page;

  /// Nome do livro: o do livro vinculado, senão o do capítulo.
  String? get displayBookName {
    final linkedTitle = book?.publication?.title;
    if (linkedTitle != null && linkedTitle.isNotEmpty) return linkedTitle;
    return book_name;
  }

  /// ISBN: o do livro vinculado, senão o do capítulo.
  String? get displayIsbn {
    final bookIsbn = book?.isbn;
    if (bookIsbn != null && bookIsbn.isNotEmpty) return bookIsbn;
    return isbn;
  }

  /// Intervalo de páginas ("120 - 145") ou só a ponta informada; vazio se
  /// nenhuma.
  String get pageRange {
    if (start_page != null && end_page != null) {
      return '$start_page - $end_page';
    }
    if (start_page != null) return 'A partir da $start_page';
    if (end_page != null) return 'Até a $end_page';
    return '';
  }

  @override
  String toString() {
    return 'BookChapters{publication: $publication, book_name: $book_name, chapter_number: $chapter_number, book: $book, isbn: $isbn, start_page: $start_page, end_page: $end_page}';
  }

  factory BookChapters.fromMap(Map<String, dynamic> map) {
    return BookChapters(
      publication: map.containsKey('publication') && map['publication'] != null
          ? Publications.fromMap(map['publication'] ?? {})
          : null,
      book_name: (map['book_name'] ?? '') as String,
      chapter_number: (map['chapter_number'] ?? 0) as num,
      // Livro aninhado ou só `book_id` (aí o ISBN vem do capítulo).
      book: map['book'] is Map
          ? Books.fromMap(Map<String, dynamic>.from(map['book']))
          : (map['book_id'] != null
              ? Books(publication: Publications(id: map['book_id'] as int?))
              : null),
      isbn: map['isbn'] as String?,
      start_page: int.tryParse(map['start_page']?.toString() ?? ''),
      end_page: int.tryParse(map['end_page']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toMap() => {
        'publication_id': publication!.id,
        'book_name': book_name!,
        'chapter_number': chapter_number!,
        // Sempre enviado (null sem livro) para permitir desvincular.
        'book_id': book?.publication?.id,
        'isbn': isbn,
        'start_page': start_page,
        'end_page': end_page,
      };
}
