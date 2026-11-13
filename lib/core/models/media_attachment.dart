/// Contrato comum das mídias persistidas (notícias, eventos, projetos).
abstract class MediaAttachment {
  int? get id;
  String? get name;
  String? get media;
}
