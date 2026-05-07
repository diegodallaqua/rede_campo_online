import '../../publications/models/publications.dart';

class BookChapters {
  BookChapters({
    this.publication,
    this.book_name,
    this.chapter_number,
  });

  Publications? publication;
  String? book_name;
  String? chapter_number;

  @override
  String toString() {
    return 'Books{publication: $publication, book_name: $book_name, chapter_number: $chapter_number}';
  }

  factory BookChapters.fromMap(Map<String, dynamic> map) {
    return BookChapters(
      publication: map.containsKey('publication') && map['publication'] != null ? Publications.fromMap(map['publication'] ?? {}) : null,
      book_name: (map['book_name'] ?? '') as String,
      chapter_number: (map['chapter_number'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'publication_id': publication!.id,
    'book_name': book_name!,
    'chapter_number': chapter_number!,
  };
}

