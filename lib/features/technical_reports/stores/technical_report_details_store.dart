import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../core/utils/repositories/translation_repository.dart';

part 'technical_report_details_store.g.dart';

class TechnicalReportDetailsStore = TechnicalReportDetailsStoreBase
    with _$TechnicalReportDetailsStore;

abstract class TechnicalReportDetailsStoreBase with Store {
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
        'TechnicalReportDetailsStore: Erro ao traduzir abstract',
        error: e.toString(),
        stackTrace: s,
      );
    } finally {
      setTranslation(false);
    }
  }
}
