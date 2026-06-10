import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../core/utils/repositories/translation_repository.dart';

part 'thesis_details_store.g.dart';

class ThesisDetailsStore = ThesisDetailsStoreBase with _$ThesisDetailsStore;

abstract class ThesisDetailsStoreBase with Store {
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
        'ThesisDetailsStore: Erro ao traduzir abstract',
        error: e.toString(),
        stackTrace: s,
      );
    } finally {
      setTranslation(false);
    }
  }
}
