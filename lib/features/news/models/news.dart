import 'package:rede_campo_online/core/models/research_areas.dart';

import '../../members/models/members.dart';
import '../../projects/models/projects.dart';

class News {
  News(
      {this.id,
      this.project,
      this.member,
      this.title,
      this.description,
      this.content,
      this.publication_date,
      this.research_areas});

  int? id;
  Projects? project;
  Members? member;
  String? title;
  String? description;
  String? content;
  DateTime? publication_date;
  List<ResearchAreas>? research_areas;

  @override
  String toString() {
    return 'News{id: $id, project: $project, member: $member, title: $title, description: $description, content: $content, publication_date: $publication_date, research_areas: $research_areas}';
  }

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      id: map['id'],
      project: map.containsKey('project') && map['project'] != null
          ? Projects.fromMap(map['project'] ?? {})
          : null,
      member: map.containsKey('member') && map['member'] != null
          ? Members.fromMap(map['member'] ?? {})
          : null,
      title: (map['title'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      content: (map['content'] ?? '') as String,
      publication_date: map['publication_date'] != null
          ? DateTime.parse(map['publication_date'])
          : null,
      research_areas: map.containsKey('research_areas')
          ? List<ResearchAreas>.from((map['research_areas'] ?? [])
              .map((x) => ResearchAreas.fromMap(x)))
          : [],
    );
  }

  Map<String, dynamic> toMap() => {
        if (project?.id != null) 'project_id': project!.id,
        'member_id': member!.id!,
        'title': title,
        'description': description,
        'content': content,
        'publication_date':
            publication_date?.toIso8601String().split('T').first,
        'research_area_ids': research_areas?.map((ra) => ra.id).toList() ?? [],
      };
}
