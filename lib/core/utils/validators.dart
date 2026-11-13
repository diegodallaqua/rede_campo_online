/// URL http(s) com host. Bloqueia esquemas como `javascript:` e `data:`.
bool isHttpUrl(String value) {
  final uri = Uri.tryParse(value.trim());
  return uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty;
}

/// ISBN-10 ou ISBN-13, com ou sem hífens/espaços.
bool isIsbn(String value) => RegExp(r'^(\d{9}[\dXx]|\d{13})$')
    .hasMatch(value.replaceAll(RegExp(r'[\s-]'), ''));
