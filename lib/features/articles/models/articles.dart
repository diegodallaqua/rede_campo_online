import 'package:rede_campo_online/features/publications/models/publications.dart';

class Articles {
  Articles({
    this.publication,
    this.journal_name,
    this.volume,
    this.issue,
    this.pages,
    this.publisher,
  });

  Publications? publication;
  String? journal_name;
  String? volume;
  String? issue;
  String? pages;
  String? publisher;

  @override
  String toString() {
    return 'Articles{publication: $publication, journal_name: $journal_name, volume: $volume, issue: $issue, pages: $pages, publisher: $publisher}';
  }

  factory Articles.fromMap(Map<String, dynamic> map) {
    return Articles(
      publication: map.containsKey('publication') && map['publication'] != null ? Publications.fromMap(map['publication'] ?? {}) : null,
      journal_name: (map['journal_name'] ?? '') as String,
      volume: (map['volume'] ?? '') as String,
      issue: (map['issue'] ?? '') as String,
      pages: (map['pages'] ?? '') as String,
      publisher: (map['publisher'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'publication_id': publication!.id,
    'journal_name': journal_name!,
    'volume': volume,
    'issue': issue,
    'pages': pages,
    'publisher': publisher,
  };
}
