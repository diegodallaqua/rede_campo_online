/// Tipos de publicação suportados. O registro do tipo é criado junto com a
/// publicação e não pode ser alterado na edição.
enum PublicationType {
  article('Artigo'),
  book('Livro'),
  bookChapter('Capítulo de Livro'),
  academicWork('Trabalho Acadêmico');

  final String label;

  const PublicationType(this.label);

  /// Converte o `publication_type` da API. `thesis` é aceito por
  /// compatibilidade com o nome anterior do tipo.
  static PublicationType? fromApi(String? value) {
    switch (value) {
      case 'article':
        return PublicationType.article;
      case 'book':
        return PublicationType.book;
      case 'book_chapter':
        return PublicationType.bookChapter;
      case 'academic_work':
      case 'thesis':
        return PublicationType.academicWork;
    }
    return null;
  }
}
