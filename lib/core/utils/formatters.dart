import 'package:intl/intl.dart';

import '../models/addresses.dart';

extension StringExtension on String {
  bool isEmailValid() {
    final RegExp regex = RegExp(
        r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$");
    return regex.hasMatch(this);
  }
}

extension DateTimeExtension on DateTime {
  String formattedDate() => DateFormat('dd/MM/yyyy', 'pt-BR').format(this);

  String formattedTime() => DateFormat('HH:mm', 'pt-BR').format(this);

  bool get hasTime => hour != 0 || minute != 0;
}

String formattedLocation(Addresses? address) {
  final city = address?.city?.name;
  final state = address?.city?.state?.name;
  if (city != null && city.isNotEmpty && state != null && state.isNotEmpty) {
    return '$city, $state';
  }
  if (city != null && city.isNotEmpty) return city;
  return 'Local não informado';
}

String formattedAddress(Addresses address) {
  final parts = <String>[];

  if (address.street != null && address.street!.isNotEmpty) {
    final street = address.number != null && address.number! > 0
        ? '${address.street}, ${address.number}'
        : address.street!;
    parts.add(street);
  }

  final cityParts = <String>[];
  if (address.city?.name != null && address.city!.name!.isNotEmpty) {
    cityParts.add(address.city!.name!);
  }
  if (address.city?.state != null && address.city!.state!.name!.isNotEmpty) {
    cityParts.add(address.city!.state!.name!);
  }
  if (cityParts.isNotEmpty) {
    parts.add(cityParts.join(', '));
  }

  return parts.join(' - ');
}
