import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/articles/models/articles.dart';
import '../../features/articles/repositories/articles_repository.dart';
import '../../features/book_chapters/models/book_chapters.dart';
import '../../features/book_chapters/repositories/book_chapters_repository.dart';
import '../../features/books/models/books.dart';
import '../../features/books/repositories/books_repository.dart';
import '../../features/publications/models/publications.dart';
import '../../features/thesis/models/thesis.dart';
import '../../features/thesis/repositories/thesis_repository.dart';
import '../models/organizations.dart';
import '../ui/theme/custom_colors.dart';

/// Resolve o tipo concreto de uma publicação e navega para a tela de detalhe
/// correspondente (artigo, livro, capítulo de livro ou tese).
///
/// As rotas de detalhe exigem o modelo tipado em `extra`. O tipo e seus
/// atributos chegam inline em `publication_type`/`details`; quando ausentes
/// (formato antigo), são buscados nos endpoints de tipo por id de publicação.
Future<void> openPublicationDetails(
  BuildContext context,
  Publications publication,
) async {
  final id = publication.id;
  if (id == null) return;

  final inline = _buildFromDetails(publication);
  if (inline != null) {
    _push(context, inline);
    return;
  }

  final fetched = await _fetchTyped(id);
  if (!context.mounted) return;

  if (fetched == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Não foi possível abrir os detalhes desta publicação.'),
        backgroundColor: CustomColors.danger_red,
      ),
    );
    return;
  }

  _push(context, fetched);
}

void _push(BuildContext context, Object typed) {
  if (typed is Articles) {
    context.push('/publications/articles/${typed.publication?.id}',
        extra: typed);
  } else if (typed is Books) {
    context.push('/publications/books/${typed.publication?.id}', extra: typed);
  } else if (typed is BookChapters) {
    context.push('/publications/book-chapters/${typed.publication?.id}',
        extra: typed);
  } else if (typed is Thesis) {
    context.push('/publications/thesis/${typed.publication?.id}', extra: typed);
  }
}

/// Monta o modelo tipado a partir dos atributos que vêm inline na publicação.
/// Retorna null quando o tipo é desconhecido ou `details` não foi enviado.
Object? _buildFromDetails(Publications publication) {
  final details = publication.details;
  if (details == null) return null;

  switch (publication.publication_type) {
    case 'article':
      return Articles(
        publication: publication,
        journal_name: (details['journal_name'] ?? '').toString(),
        volume: (details['volume'] ?? '').toString(),
        issue: (details['issue'] ?? '').toString(),
        pages: (details['pages'] ?? '').toString(),
        publisher: (details['publisher'] ?? '').toString(),
      );
    case 'book':
      return Books(
        publication: publication,
        publisher: (details['publisher'] ?? '').toString(),
        edition: (details['edition'] ?? '').toString(),
        cover_photo: (details['cover_photo'] ?? '').toString(),
        isbn: (details['isbn'] ?? '').toString(),
        book_url: (details['book_url'] ?? '').toString(),
      );
    case 'book_chapter':
      return BookChapters(
        publication: publication,
        book_name: (details['book_name'] ?? '').toString(),
        chapter_number:
            num.tryParse(details['chapter_number']?.toString() ?? ''),
      );
    case 'thesis':
      return Thesis(
        publication: publication,
        organization: details['organization'] is Map
            ? Organizations.fromMap(
                Map<String, dynamic>.from(details['organization']))
            : null,
        number_of_pages:
            int.tryParse(details['number_of_pages']?.toString() ?? ''),
      );
  }
  return null;
}

/// Descobre o tipo consultando cada endpoint pelo id da publicação.
Future<Object?> _fetchTyped(int publicationId) async {
  try {
    final article = await ArticlesRepository().findByPublicationId(
      publicationId,
    );
    if (article != null) return article;

    final book = await BooksRepository().findByPublicationId(publicationId);
    if (book != null) return book;

    final chapter = await BookChaptersRepository().findByPublicationId(
      publicationId,
    );
    if (chapter != null) return chapter;

    return await ThesisRepository().findByPublicationId(publicationId);
  } catch (_) {
    return null;
  }
}
