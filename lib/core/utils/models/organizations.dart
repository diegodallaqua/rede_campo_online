import 'addresses.dart';

class Organizations {
  Organizations({
    this.id,
    this.address,
    this.name,
  });

  int? id;
  Addresses? address;
  String? name;

  @override
  String toString() {
    return 'Organizations{id: $id, address: $address, name: $name}';
  }

  factory Organizations.fromMap(Map<String, dynamic> map) {
    return Organizations(
      id: map['id'],
      address: map.containsKey('address') && map['address'] != null ? Addresses.fromMap(map['address'] ?? {}) : null,
      name: (map['name'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() => {
    if (address?.id != null) 'address_id': address!.id,
    'name': name,
  };
}
