class MemberRoles {
  MemberRoles({
    this.id,
    this.name,
  });

  String? id;
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
}
