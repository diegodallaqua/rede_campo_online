import '../../../core/utils/models/organizations.dart';
import '../../publications/models/publications.dart';

class TechnicalReports {
  TechnicalReports({
    this.publication,
    this.organization,
    this.number_of_pages,
  });

  Publications? publication;
  Organizations? organization;
  int? number_of_pages;

  @override
  String toString() {
    return 'TechnicalReports{publication: $publication, organization: $organization, number_of_pages: $number_of_pages}';
  }

  factory TechnicalReports.fromMap(Map<String, dynamic> map) {
    return TechnicalReports(
      publication: map.containsKey('publication') && map['publication'] != null ? Publications.fromMap(map['publication'] ?? {}) : null,
      organization: map.containsKey('organization') && map['organization'] != null ? Organizations.fromMap(map['organization'] ?? {}) : null,
      number_of_pages: (map['number_of_pages'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() => {
    'publication_id': publication!.id,
    'organization_id': organization!.id,
    'number_of_pages': number_of_pages!,
  };
}
