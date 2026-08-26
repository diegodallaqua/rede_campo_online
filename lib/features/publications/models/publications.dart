import 'package:rede_campo_online/core/models/research_areas.dart';

import '../../../core/models/contributor.dart';
import '../../projects/models/projects.dart';

class Publications {
  Publications(
      {this.id,
      this.title,
      this.abstract,
      this.publication_date,
      this.doi,
      this.publication_type,
      this.details,
      this.project,
      this.research_areas,
      this.contributors});

  int? id;
  String? title;
  String? abstract;
  DateTime? publication_date;
  String? doi;
  String? publication_type;
  Map<String, dynamic>? details;
  Projects? project;
  List<ResearchAreas>? research_areas;
  List<Contributors>? contributors;

  @override
  String toString() {
    return 'Publications{id: $id, title: $title, abstract: $abstract, publication_date: $publication_date, doi: $doi, project: $project, research_areas: $research_areas, contributors: $contributors}';
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
      // O tipo vem como `details.type`; aceita também `publication_type` no
      // topo para compatibilidade com formatos anteriores.
      publication_type: (map['publication_type'] ??
          (map['details'] is Map ? map['details']['type'] : null)) as String?,
      details: map['details'] is Map
          ? Map<String, dynamic>.from(map['details'])
          : null,
      project: map['project'] != null
          ? Projects.fromMap(Map<String, dynamic>.from(map['project']))
          : null,
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
        'publication_date':
            publication_date?.toIso8601String().substring(0, 10),
        if (doi != null && doi!.isNotEmpty) 'doi': doi,
        // Vínculo opcional: enviado sempre (null quando não há projeto) para
        // que a edição consiga desvincular a publicação de um projeto.
        'project_id': project?.id,
        'research_area_ids': research_areas?.map((ra) => ra.id).toList() ?? [],
      };
}
