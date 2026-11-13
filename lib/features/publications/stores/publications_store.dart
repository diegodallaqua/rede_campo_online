import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../models/publications.dart';
import '../repositories/publications_repository.dart';

part 'publications_store.g.dart';

/// Publicações recentes exibidas na Home.
class PublicationsStore = PublicationsStoreBase with _$PublicationsStore;

abstract class PublicationsStoreBase with Store {
  final _repository = PublicationsRepository();

  @observable
  ObservableList<Publications> recentPublications =
      ObservableList<Publications>();

  @observable
  bool isLoadingRecent = false;

  @observable
  String? recentPublicationsError;

  @computed
  bool get showRecentProgress => isLoadingRecent && recentPublications.isEmpty;

  @action
  Future<void> loadRecentPublications() async {
    // Evita fetch duplicado se já estiver carregando.
    if (isLoadingRecent) return;

    isLoadingRecent = true;
    recentPublicationsError = null;

    try {
      final result = await _repository.findAllPublications(page: 1);
      recentPublications
        ..clear()
        ..addAll(result);
    } catch (e, s) {
      log('PublicationsStore: Erro ao carregar Publicações recentes',
          error: e.toString(), stackTrace: s);
      recentPublicationsError = e.toString();
    } finally {
      isLoadingRecent = false;
    }
  }

  /// Recarrega as publicações recentes da Home.
  @action
  Future<void> refreshRecentPublications() async {
    recentPublications.clear();
    await loadRecentPublications();
  }
}
