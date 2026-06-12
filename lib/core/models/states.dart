class States {
  States({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  @override
  String toString() {
    return 'States{id: $id, name: $name}';
  }

  factory States.fromMap(Map<String, dynamic> map) {
    return States(
      id: map['id'],
      name: (map['name'] ?? '') as String,
    );
  }
}
