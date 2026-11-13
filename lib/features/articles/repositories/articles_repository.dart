import '../../../core/global/constants/api_constants.dart';
import '../../publications/repositories/publication_type_repository.dart';
import '../models/articles.dart';

class ArticlesRepository extends PublicationTypeRepository<Articles> {
  const ArticlesRepository();

  @override
  String get path => articlesURL;

  @override
  String get singular => 'Artigo';

  @override
  String get plural => 'Artigos';

  @override
  Articles fromMap(Map<String, dynamic> map) => Articles.fromMap(map);

  @override
  Map<String, dynamic> toMap(Articles item) => item.toMap();

  @override
  int? publicationIdOf(Articles item) => item.publication?.id;
}
