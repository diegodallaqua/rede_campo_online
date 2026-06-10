import '../../publications/models/publications.dart';

class Books {
  Books({
    this.publication,
    this.publisher,
    this.edition,
    this.cover_photo,
    this.isbn,
    this.book_url,
  });

  Publications? publication;
  String? publisher;
  String? edition;
  String? cover_photo;
  String? isbn;
  String? book_url;

  @override
  String toString() {
    return 'Books{publication: $publication, publisher: $publisher, edition: $edition, cover_photo: $cover_photo, isbn: $isbn, book_url: $book_url}';
  }

  factory Books.fromMap(Map<String, dynamic> map) {
    return Books(
      publication: map.containsKey('publication') && map['publication'] != null
          ? Publications.fromMap(map['publication'] ?? {})
          : null,
      publisher: (map['publisher'] ?? '') as String,
      edition: (map['edition'] ?? '') as String,
      cover_photo: (map['cover_photo'] ?? '') as String,
      isbn: (map['isbn'] ?? '') as String,
      book_url: (map['book_url'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'publication_id': publication!.id,
        'publisher': publisher!,
        'edition': edition!,
        'cover_photo': cover_photo!,
        'isbn': isbn!,
        'book_url': book_url!,
      };
}
