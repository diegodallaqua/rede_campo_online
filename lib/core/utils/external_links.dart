import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

const _allowedSchemes = {'http', 'https', 'mailto', 'tel'};

/// Abre um link externo em nova aba (ou no app do sistema).
///
/// Ignora URLs vazias, inválidas ou com esquema fora de http(s), mailto e
/// tel, já que vários links vêm da API (ex.: bloqueia `javascript:`).
Future<void> openExternalUrl(String? url) async {
  final uri = Uri.tryParse(url?.trim() ?? '');
  if (uri == null || !_allowedSchemes.contains(uri.scheme.toLowerCase())) {
    return;
  }
  try {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );
  } catch (e) {
    log('Não foi possível abrir o link', error: e);
  }
}

/// URL de um DOI, aceitando o identificador puro ou a URL completa.
String doiUrl(String doi) =>
    doi.startsWith('http') ? doi : 'https://doi.org/$doi';
