/// Tipos de publicação suportados. O registro do tipo é criado junto com a
/// publicação e não pode ser alterado na edição.
enum PublicationType {
  article('Artigo'),
  book('Livro'),
  bookChapter('Capítulo de Livro'),
  thesis('Tese');

  final String label;

  const PublicationType(this.label);
}
