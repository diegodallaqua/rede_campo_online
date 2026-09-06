class AcademicWorkType {
  AcademicWorkType({
    this.id,
    this.name,
    this.degree_level,
  });

  int? id;
  String? name;
  String? degree_level;

  /// Rótulo exibido nas listagens e telas de detalhe, no formato
  /// "<name> de <degree_level>" (ex.: "Dissertação de Mestrado"). Quando
  /// apenas um dos dois campos existe, retorna o que estiver preenchido.
  String get label {
    final type = name ?? '';
    final level = degree_level ?? '';
    if (type.isNotEmpty && level.isNotEmpty) return '$type de $level';
    return type.isNotEmpty ? type : level;
  }

  @override
  String toString() {
    return 'AcademicWorkType{id: $id, name: $name, degree_level: $degree_level}';
  }

  factory AcademicWorkType.fromMap(Map<String, dynamic> map) {
    return AcademicWorkType(
      id: map['id'],
      name: (map['name'] ?? '') as String,
      degree_level: (map['degree_level'] ?? '') as String,
    );
  }
}
