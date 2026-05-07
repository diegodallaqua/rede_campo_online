import '../../publications/models/publications.dart';

class Books {
  Books({
    this.publication,
    this.publisher,
    this.edition,
  });

  Publications? publication;
  String? publisher;
  String? edition;

  @override
  String toString() {
    return 'Books{publication: $publication, publisher: $publisher, edition: $edition}';
  }

  factory Books.fromMap(Map<String, dynamic> map) {
    return Books(
      publication: map.containsKey('publication') && map['publication'] != null ? Publications.fromMap(map['publication'] ?? {}) : null,
      publisher: (map['publisher'] ?? '') as String,
      edition: (map['edition'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'publication_id': publication!.id,
    'publisher': publisher!,
    'edition': edition!,
  };
}

