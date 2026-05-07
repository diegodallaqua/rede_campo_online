import 'cities.dart';

class Addresses {
  Addresses({
    this.id,
    this.city,
    this.street,
    this.neighborhood,
    this.number,
    this.cep,
    this.complement
  });

  String? id;
  Cities? city;
  String? street;
  String? neighborhood;
  int? number;
  String? cep;
  String? complement;


  @override
  String toString() {
    return 'Addresses{id: $id, city: $city, street: $street, neighborhood: $neighborhood, number: $number, cep: $cep, complement: $complement}';
  }

  factory Addresses.fromMap(Map<String, dynamic> map) {
    return Addresses(
      id: map['id'],
      city: map.containsKey('city') && map['city'] != null ? Cities.fromMap(map['city'] ?? {}) : null,
      street: (map['street'] ?? '') as String,
      neighborhood: (map['neighborhood'] ?? '') as String,
      number: (map['number'] ?? 0) as int,
      cep: (map['cep'] ?? '') as String,
      complement: (map['complement'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city_id': city!.id,
      'street': street!,
      'neighborhood': neighborhood!,
      'number': number!,
      'cep': cep!,
      'complement': complement,
    };
  }
}
