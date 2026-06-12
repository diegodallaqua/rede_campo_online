class ContributorRoles {
  ContributorRoles({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  @override
  String toString() {
    return 'ContributorRoles{id: $id, name: $name}';
  }

  factory ContributorRoles.fromMap(Map<String, dynamic> map) {
    return ContributorRoles(
      id: map['id'],
      name: (map['name'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };
}
