import 'package:flutter/material.dart';

import '../../../../features/admin/publications/models/publication_type.dart';
import '../../../../features/publications/models/publications.dart';

/// Rótulos e ícones de uma publicação, comuns aos cards desktop e mobile.
extension PublicationTileInfo on Publications {
  PublicationType? get _type => PublicationType.fromApi(publication_type);

  String get typeLabel => _type?.label ?? 'Publicação';

  IconData get typeIcon => switch (_type) {
        PublicationType.article => Icons.article_outlined,
        PublicationType.book => Icons.menu_book_outlined,
        PublicationType.bookChapter => Icons.auto_stories_outlined,
        PublicationType.academicWork => Icons.school_outlined,
        null => Icons.description_outlined,
      };

  /// Autores em ordem ("Ana, Bruno +2"), ou null sem contribuidores.
  String? authorsLabel({int max = 2}) {
    final ordered = [...?contributors]
      ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    final names = ordered
        .map((c) => (c.member?.name ?? c.external_author?.name ?? '').trim())
        .where((name) => name.isNotEmpty)
        .toList();
    return _joinWithOverflow(names, max);
  }

  /// Áreas de pesquisa ("Solos, Irrigação +1"), ou null quando não há nenhuma.
  String? areasLabel({int max = 2}) {
    final names = (research_areas ?? [])
        .map((area) => (area.name ?? '').trim())
        .where((name) => name.isNotEmpty)
        .toList();
    return _joinWithOverflow(names, max);
  }
}

String? _joinWithOverflow(List<String> items, int max) {
  if (items.isEmpty) return null;
  if (items.length <= max) return items.join(', ');
  return '${items.take(max).join(', ')} +${items.length - max}';
}
