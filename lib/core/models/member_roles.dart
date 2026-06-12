class MemberRoles {
  MemberRoles({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  @override
  String toString() {
    return 'MemberRoles{id: $id, name: $name}';
  }

  factory MemberRoles.fromMap(Map<String, dynamic> map) {
    return MemberRoles(
      id: map['id'],
      name: (map['name'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };
}
