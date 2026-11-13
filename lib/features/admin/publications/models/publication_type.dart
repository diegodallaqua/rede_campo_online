/// Tipos de publicação. O tipo é fixado na criação.
enum PublicationType {
  article('Artigo'),
  book('Livro'),
  bookChapter('Capítulo de Livro'),
  academicWork('Trabalho Acadêmico');

  final String label;

  const PublicationType(this.label);

  /// Converte o `publication_type` da API (`thesis` por compatibilidade).
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
