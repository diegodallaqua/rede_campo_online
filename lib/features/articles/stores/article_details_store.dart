import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../core/utils/repositories/translation_repository.dart';

part 'article_details_store.g.dart';

class ArticleDetailsStore = ArticleDetailsStoreBase with _$ArticleDetailsStore;

abstract class ArticleDetailsStoreBase with Store {
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
        'ArticleDetailsStore: Erro ao traduzir abstract',
        error: e.toString(),
        stackTrace: s,
      );
    } finally {
      setTranslation(false);
    }
  }
}
