import '../../../core/models/project_types.dart';
import '../../../core/models/research_areas.dart';
import '../../members/models/members.dart';

class Projects {
  Projects(
      {this.id,
      this.projectType,
      this.name,
      this.description,
      this.status,
      this.begin_date,
      this.end_date,
      this.research_areas,
      this.members});

  int? id;
  ProjectTypes? projectType;
  String? name;
  String? description;
  bool? status;
  DateTime? begin_date;
  DateTime? end_date;
  List<ResearchAreas>? research_areas;
  List<Members>? members;

  @override
  String toString() {
    return 'Projects{id: $id, projectType: $projectType, name: $name, description: $description, status, $status, begin_date: $begin_date, end_date: $end_date, research_areas:$research_areas, members:$members}';
  }

  factory Projects.fromMap(Map<String, dynamic> map) {
    return Projects(
      id: map['id'],
      projectType: map.containsKey('projectType') && map['projectType'] != null
          ? ProjectTypes.fromMap(map['projectType'] ?? {})
          : null,
      name: (map['name'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      status: (map['status'] ?? false) as bool,
      begin_date:
          map['begin_date'] != null ? DateTime.parse(map['begin_date']) : null,
      end_date:
          map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
      research_areas: map.containsKey('research_areas')
          ? List<ResearchAreas>.from((map['research_areas'] ?? [])
              .map((x) => ResearchAreas.fromMap(x)))
          : [],
      members: map.containsKey('members')
          ? List<Members>.from(
              (map['members'] ?? []).map((x) => Members.fromMap(x)))
          : [],
    );
  }

  Map<String, dynamic> toMap() => {
        'project_type_id': projectType?.id,
        'name': name!,
        'description': description!,
        'status': status ?? true,
        'begin_date': begin_date?.toIso8601String().split('T').first,
        'end_date': end_date?.toIso8601String().split('T').first,
        'research_area_ids': research_areas?.map((ra) => ra.id).toList() ?? [],
        'member_ids': members?.map((m) => m.id).toList() ?? [],
      };
}
