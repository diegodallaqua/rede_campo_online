import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/features/publications/models/publications.dart';
import 'package:rede_campo_online/features/publications/repositories/publications_repository.dart';

part 'admin_create_publication_store.g.dart';

class AdminCreatePublicationStore = AdminCreatePublicationStoreBase
    with _$AdminCreatePublicationStore;

abstract class AdminCreatePublicationStoreBase with Store {
  final _repository = PublicationsRepository();

  @readonly
  bool _loading = false;

  @readonly
  String? _errorMessage;

  @readonly
  bool _success = false;

  @action
  void clearState() {
    _errorMessage = null;
    _success = false;
  }

  @action
  Future<void> submit({
    required String title,
    required String abstract,
    required DateTime publicationDate,
    String? doi,
  }) async {
    _loading = true;
    _errorMessage = null;
    _success = false;

    try {
      final publication = Publications(
        title: title.trim(),
        abstract: abstract.trim(),
        publication_date: publicationDate,
        doi: doi?.trim(),
        research_areas: [],
        contributors: [],
      );
      await _repository.createPublication(publication);
      _success = true;
    } catch (e) {
      _errorMessage = e is String ? e : 'Erro ao criar publicação.';
    } finally {
      _loading = false;
    }
  }
}
