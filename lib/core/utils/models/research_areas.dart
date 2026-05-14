class ResearchAreas {
  ResearchAreas({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  @override
  String toString() {
    return 'ResearchAreas{id: $id, name: $name}';
  }

  factory ResearchAreas.fromMap(Map<String, dynamic> map) {
    return ResearchAreas(
      id: map['id'],
      name: (map['name'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name!
  };
}
