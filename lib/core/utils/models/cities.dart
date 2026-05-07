import 'states.dart';

class Cities {
  Cities({
    this.id,
    this.name,
    this.state,
  });

  String? id;
  String? name;
  States? state;

  @override
  String toString() {
    return 'States{id: $id, name: $name, state: $state}';
  }

  factory Cities.fromMap(Map<String, dynamic> map) {
    return Cities(
      id: map['id'],
      name: (map['name'] ?? '') as String,
      state: map.containsKey('state') && map['state'] != null ? States.fromMap(map['state'] ?? {}) : null,
    );
  }
}
