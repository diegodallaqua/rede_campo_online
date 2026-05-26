import 'package:rede_campo_online/core/utils/models/research_areas.dart';

import '../../../core/utils/models/contributor.dart';

class Publications {
  Publications(
      {this.id,
      this.title,
      this.abstract,
      this.publication_date,
      this.doi,
      this.research_areas,
      this.contributors});

  int? id;
  String? title;
  String? abstract;
  DateTime? publication_date;
  String? doi;
  List<ResearchAreas>? research_areas;
  List<Contributors>? contributors;

  @override
  String toString() {
    return 'Publications{id: $id, title: $title, abstract: $abstract, publication_date: $publication_date, doi: $doi, research_areas: $research_areas, contributors: $contributors}';
  }

  factory Publications.fromMap(Map<String, dynamic> map) {
    return Publications(
      id: map['id'],
      title: (map['title'] ?? '') as String,
      abstract: (map['abstract'] ?? '') as String,
      publication_date: map['publication_date'] != null
          ? DateTime.parse(map['publication_date'])
          : null,
      doi: (map['doi'] ?? '') as String,
      research_areas: map.containsKey('research_areas')
          ? List<ResearchAreas>.from((map['research_areas'] ?? [])
              .map((x) => ResearchAreas.fromMap(x)))
          : [],
      contributors: map.containsKey('contributors')
          ? List<Contributors>.from(
              (map['contributors'] ?? []).map((x) => Contributors.fromMap(x)))
          : [],
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title!,
        'abstract': abstract!,
        'publication_date': publication_date!,
        'doi': doi,
        'research_area_ids': research_areas!.map((city) => city.id).toList(),
      };
}
