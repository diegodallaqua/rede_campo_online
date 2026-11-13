import 'package:flutter/material.dart';

/// Escala tipográfica. Sem cor: aplique via `copyWith`.
abstract class CustomTextStyles {
  static const String _slab = 'RobotoSlab';

  // Título principal da página inicial.
  static const TextStyle heroTitleDesktop = TextStyle(
    fontFamily: _slab,
    fontSize: 72,
    fontWeight: FontWeight.w900,
    height: 1.12,
  );
  static const TextStyle heroTitleMobile = TextStyle(
    fontFamily: _slab,
    fontSize: 32,
    fontWeight: FontWeight.w900,
    height: 1.25,
  );

  // Título das páginas internas (Projetos, Publicações, Eventos...).
  static const TextStyle pageTitleDesktop = TextStyle(
    fontFamily: _slab,
    fontSize: 64,
    fontWeight: FontWeight.w900,
    height: 1.1,
  );
  static const TextStyle pageTitleMobile = TextStyle(
    fontFamily: _slab,
    fontSize: 40,
    fontWeight: FontWeight.w900,
    height: 1.15,
  );

  // Títulos de seção (Notícias Recentes, Artigos, Livros...).
  static const TextStyle sectionTitleDesktop = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    height: 1.2,
  );
  static const TextStyle sectionTitleMobile = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    height: 1.2,
  );

  // Subtítulos e textos de apoio logo abaixo de um título.
  static const TextStyle leadDesktop = TextStyle(fontSize: 20, height: 1.5);
  static const TextStyle leadMobile = TextStyle(fontSize: 17, height: 1.5);

  // Título dos cards de listagem.
  static const TextStyle cardTitleDesktop = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.35,
  );
  static const TextStyle cardTitleMobile = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.35,
  );

  // Texto corrido.
  static const TextStyle bodyDesktop = TextStyle(fontSize: 16, height: 1.7);
  static const TextStyle bodyMobile = TextStyle(fontSize: 15, height: 1.65);

  // Datas, local, áreas de pesquisa e mensagens de estado.
  static const TextStyle meta = TextStyle(fontSize: 13, height: 1.3);

  // Selos e rótulos em caixa alta.
  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
    height: 1.3,
  );

  // Rótulo de botões.
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
}
