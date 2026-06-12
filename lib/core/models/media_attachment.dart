/// Contrato comum às mídias persistidas (notícias, eventos, projetos),
/// permitindo que componentes de UI genéricos exibam qualquer uma delas.
abstract class MediaAttachment {
  int? get id;
  String? get name;
  String? get media;
}
