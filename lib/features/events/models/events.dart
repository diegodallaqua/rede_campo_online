import '../../../core/utils/models/addresses.dart';
import '../../projects/models/projects.dart';

class Events {
  Events({
    this.id,
    this.project,
    this.address,
    this.name,
    this.description,
    this.registration_url,
    this.date
  });

  int? id;
  Projects? project;
  Addresses? address;
  String? name;
  String? description;
  String? registration_url;
  DateTime? date;

  @override
  String toString() {
    return 'Events{id: $id, project: $project, address: $address, name: $name, description: $description, registration_url: $registration_url, date: $date}';
  }

  factory Events.fromMap(Map<String, dynamic> map) {
    return Events(
      id: map['id'],
      project: map.containsKey('project') && map['project'] != null ? Projects.fromMap(map['project'] ?? {}) : null,
      address: map.containsKey('address') && map['address'] != null ? Addresses.fromMap(map['address'] ?? {}) : null,
      name: (map['name'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      registration_url: (map['registration_url'] ?? '') as String,
      date: (map['date'] ?? '') as DateTime,
    );
  }

  Map<String, dynamic> toMap() => {
    'project_id': project!.id,
    'address_id': address!.id!,
    'name': name,
    'description': description,
    'registration_url': registration_url,
    'date': date,
  };
}
