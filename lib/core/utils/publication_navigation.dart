import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/articles/models/articles.dart';
import '../../features/articles/repositories/articles_repository.dart';
import '../../features/book_chapters/models/book_chapters.dart';
import '../../features/book_chapters/repositories/book_chapters_repository.dart';
import '../../features/books/models/books.dart';
import '../../features/books/repositories/books_repository.dart';
import '../../features/publications/models/publications.dart';
import '../../features/academic_works/models/academic_work.dart';
import '../../features/academic_works/repositories/academic_work_repository.dart';
import '../models/academic_work_types.dart';
import '../models/organizations.dart';
import '../ui/theme/custom_colors.dart';

/// Navega para o detalhe conforme o tipo da publicação.
///
/// Usa o tipo inline (`publication_type`/`details`); se ausente (formato
/// antigo), consulta os endpoints de tipo.
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
  } else if (typed is AcademicWork) {
    context.push('/publications/academic-works/${typed.publication?.id}',
        extra: typed);
  }
}

/// Monta o modelo tipado com os dados inline; null se o tipo for
/// desconhecido ou faltar `details`.
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
        book: details['book'] is Map
            ? Books.fromMap(Map<String, dynamic>.from(details['book']))
            : (details['book_id'] != null
                ? Books(
                    publication: Publications(
                      id: int.tryParse(details['book_id'].toString()),
                    ),
                  )
                : null),
        isbn: details['isbn']?.toString(),
        start_page: int.tryParse(details['start_page']?.toString() ?? ''),
        end_page: int.tryParse(details['end_page']?.toString() ?? ''),
      );
    // `thesis` é aceito por compatibilidade com o nome anterior do tipo.
    case 'academic_work':
    case 'thesis':
      return AcademicWork(
        publication: publication,
        organization: details['organization'] is Map
            ? Organizations.fromMap(
                Map<String, dynamic>.from(details['organization']))
            : null,
        number_of_pages:
            int.tryParse(details['number_of_pages']?.toString() ?? ''),
        academic_work_type: details['academic_work_type'] is Map
            ? AcademicWorkType.fromMap(
                Map<String, dynamic>.from(details['academic_work_type']))
            : null,
        defense_date: details['defense_date'] != null
            ? DateTime.tryParse(details['defense_date'].toString())
            : null,
      );
  }
  return null;
}

/// Descobre o tipo consultando cada endpoint pelo id da publicação.
Future<Object?> _fetchTyped(int publicationId) async {
  try {
    final article = await const ArticlesRepository().findByPublicationId(
      publicationId,
    );
    if (article != null) return article;

    final book =
        await const BooksRepository().findByPublicationId(publicationId);
    if (book != null) return book;

    final chapter = await const BookChaptersRepository().findByPublicationId(
      publicationId,
    );
    if (chapter != null) return chapter;

    return await const AcademicWorkRepository()
        .findByPublicationId(publicationId);
  } catch (_) {
    return null;
  }
}
