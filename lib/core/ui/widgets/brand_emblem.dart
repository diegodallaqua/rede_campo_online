import 'package:flutter/material.dart';

/// Emblema da Rede Campo recortado de `logo_icon.png`. O arquivo tem margem
/// transparente à direita; o recorte quadrado mantém só o emblema, inteiro.
class BrandEmblem extends StatelessWidget {
  final double size;

  const BrandEmblem({super.key, required this.size});

  // O emblema ocupa de 12% a 62% da largura do arquivo (proporção 2:1).
  static const Alignment _emblemAlignment = Alignment(-0.52, 0);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_icon.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
      alignment: _emblemAlignment,
      excludeFromSemantics: true,
    );
  }
}
