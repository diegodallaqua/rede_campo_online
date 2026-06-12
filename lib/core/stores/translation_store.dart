import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../repositories/translation_repository.dart';

part 'translation_store.g.dart';

/// Traduz o resumo (abstract) de uma publicação para o inglês, expondo o
/// progresso e o resultado para as seções de detalhe (artigos, dissertações).
class TranslationStore = TranslationStoreBase with _$TranslationStore;

abstract class TranslationStoreBase with Store {
  @observable
  String? summary;

  @observable
  bool translating = false;

  @action
  void setTranslation(bool? value) {
    translating = value ?? false;
  }

  @action
  Future<void> fetchTranslation(String text) async {
    if (text.isEmpty) return;

    setTranslation(true);

    try {
      final translated = await TranslationRepository.translateToEnglish(text);
      summary = translated;
    } catch (e, s) {
      log(
        'TranslationStore: Erro ao traduzir abstract',
        error: e.toString(),
        stackTrace: s,
      );
    } finally {
      setTranslation(false);
    }
  }
}
