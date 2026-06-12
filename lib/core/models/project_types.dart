class ProjectTypes {
  ProjectTypes({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  @override
  String toString() {
    return 'ProjectTypes{id: $id, name: $name}';
  }

  factory ProjectTypes.fromMap(Map<String, dynamic> map) {
    return ProjectTypes(
      id: map['id'],
      name: (map['name'] ?? '') as String,
    );
  }
}
