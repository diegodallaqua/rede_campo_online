import 'package:mobx/mobx.dart';

part 'filter_search_store.g.dart';

/// Termo de busca das listagens.
class FilterSearchStore = FilterSearchStoreBase with _$FilterSearchStore;

abstract class FilterSearchStoreBase with Store {
  @readonly
  String _search = '';

  @action
  void setSearch(String value) => _search = value;
}
