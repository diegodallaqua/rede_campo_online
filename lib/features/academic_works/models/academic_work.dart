import '../../../core/models/academic_work_types.dart';
import '../../../core/models/organizations.dart';
import '../../publications/models/publications.dart';

class AcademicWork {
  AcademicWork({
    this.publication,
    this.organization,
    this.number_of_pages,
    this.academic_work_type,
    this.defense_date,
  });

  Publications? publication;
  Organizations? organization;
  int? number_of_pages;
  AcademicWorkType? academic_work_type;
  DateTime? defense_date;

  @override
  String toString() {
    return 'AcademicWork{publication: $publication, organization: $organization, number_of_pages: $number_of_pages, academic_work_type: $academic_work_type, defense_date: $defense_date}';
  }

  factory AcademicWork.fromMap(Map<String, dynamic> map) {
    return AcademicWork(
      publication: map.containsKey('publication') && map['publication'] != null
          ? Publications.fromMap(map['publication'] ?? {})
          : null,
      organization:
          map.containsKey('organization') && map['organization'] != null
              ? Organizations.fromMap(map['organization'] ?? {})
              : null,
      number_of_pages: (map['number_of_pages'] ?? 0) as int,
      academic_work_type: map['academic_work_type'] != null
          ? AcademicWorkType.fromMap(
              Map<String, dynamic>.from(map['academic_work_type']))
          : null,
      defense_date: map['defense_date'] != null
          ? DateTime.tryParse(map['defense_date'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'publication_id': publication!.id,
        'organization_id': organization!.id,
        'number_of_pages': number_of_pages!,
        'academic_work_type_id': academic_work_type!.id,
        'defense_date': defense_date?.toIso8601String().substring(0, 10),
      };
}
