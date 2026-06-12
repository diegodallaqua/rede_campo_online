import '../../../core/models/media_attachment.dart';
import 'projects.dart';

class ProjectMedia implements MediaAttachment {
  ProjectMedia({this.id, this.project, this.name, this.media});

  @override
  int? id;
  Projects? project;
  @override
  String? name;
  @override
  String? media;

  @override
  String toString() {
    return 'ProjectMedia{id: $id, project: $project, name: $name, media: $media}';
  }

  factory ProjectMedia.fromMap(Map<String, dynamic> map) {
    return ProjectMedia(
      id: map['id'],
      project: map.containsKey('project') && map['project'] != null
          ? Projects.fromMap(map['project'] ?? {})
          : null,
      name: (map['name'] ?? '') as String,
      media: (map['media'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'project_id': project!.id,
        'name': name!,
        'media': media!,
      };
}
