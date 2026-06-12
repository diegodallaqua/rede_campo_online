// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_search_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FilterSearchStore on _FilterSearchStore, Store {
  Computed<bool>? _$isFilterCountComputed;

  @override
  bool get isFilterCount =>
      (_$isFilterCountComputed ??= Computed<bool>(() => super.isFilterCount,
              name: '_FilterSearchStore.isFilterCount'))
          .value;
  Computed<int>? _$getCountFilterComputed;

  @override
  int get getCountFilter =>
      (_$getCountFilterComputed ??= Computed<int>(() => super.getCountFilter,
              name: '_FilterSearchStore.getCountFilter'))
          .value;
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid =>
      (_$isFormValidComputed ??= Computed<bool>(() => super.isFormValid,
              name: '_FilterSearchStore.isFormValid'))
          .value;

  late final _$_visibleSearchAtom =
      Atom(name: '_FilterSearchStore._visibleSearch', context: context);

  bool get visibleSearch {
    _$_visibleSearchAtom.reportRead();
    return super._visibleSearch;
  }

  @override
  bool get _visibleSearch => visibleSearch;

  @override
  set _visibleSearch(bool value) {
    _$_visibleSearchAtom.reportWrite(value, super._visibleSearch, () {
      super._visibleSearch = value;
    });
  }

  late final _$_filterCountAtom =
      Atom(name: '_FilterSearchStore._filterCount', context: context);

  int get filterCount {
    _$_filterCountAtom.reportRead();
    return super._filterCount;
  }

  @override
  int get _filterCount => filterCount;

  @override
  set _filterCount(int value) {
    _$_filterCountAtom.reportWrite(value, super._filterCount, () {
      super._filterCount = value;
    });
  }

  late final _$_tradeSearchAtom =
      Atom(name: '_FilterSearchStore._tradeSearch', context: context);

  bool get tradeSearch {
    _$_tradeSearchAtom.reportRead();
    return super._tradeSearch;
  }

  @override
  bool get _tradeSearch => tradeSearch;

  @override
  set _tradeSearch(bool value) {
    _$_tradeSearchAtom.reportWrite(value, super._tradeSearch, () {
      super._tradeSearch = value;
    });
  }

  late final _$_searchAtom =
      Atom(name: '_FilterSearchStore._search', context: context);

  String get search {
    _$_searchAtom.reportRead();
    return super._search;
  }

  @override
  String get _search => search;

  @override
  set _search(String value) {
    _$_searchAtom.reportWrite(value, super._search, () {
      super._search = value;
    });
  }

  late final _$showErrorsAtom =
      Atom(name: '_FilterSearchStore.showErrors', context: context);

  @override
  bool get showErrors {
    _$showErrorsAtom.reportRead();
    return super.showErrors;
  }

  @override
  set showErrors(bool value) {
    _$showErrorsAtom.reportWrite(value, super.showErrors, () {
      super.showErrors = value;
    });
  }

  late final _$_FilterSearchStoreActionController =
      ActionController(name: '_FilterSearchStore', context: context);

  @override
  void setVisibleSearch() {
    final _$actionInfo = _$_FilterSearchStoreActionController.startAction(
        name: '_FilterSearchStore.setVisibleSearch');
    try {
      return super.setVisibleSearch();
    } finally {
      _$_FilterSearchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setVisibleSearchFalse() {
    final _$actionInfo = _$_FilterSearchStoreActionController.startAction(
        name: '_FilterSearchStore.setVisibleSearchFalse');
    try {
      return super.setVisibleSearchFalse();
    } finally {
      _$_FilterSearchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFilterCountZero() {
    final _$actionInfo = _$_FilterSearchStoreActionController.startAction(
        name: '_FilterSearchStore.setFilterCountZero');
    try {
      return super.setFilterCountZero();
    } finally {
      _$_FilterSearchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTradeSearch(bool value) {
    final _$actionInfo = _$_FilterSearchStoreActionController.startAction(
        name: '_FilterSearchStore.setTradeSearch');
    try {
      return super.setTradeSearch(value);
    } finally {
      _$_FilterSearchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearch(String value) {
    final _$actionInfo = _$_FilterSearchStoreActionController.startAction(
        name: '_FilterSearchStore.setSearch');
    try {
      return super.setSearch(value);
    } finally {
      _$_FilterSearchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void invalidSendPressed() {
    final _$actionInfo = _$_FilterSearchStoreActionController.startAction(
        name: '_FilterSearchStore.invalidSendPressed');
    try {
      return super.invalidSendPressed();
    } finally {
      _$_FilterSearchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearFilters() {
    final _$actionInfo = _$_FilterSearchStoreActionController.startAction(
        name: '_FilterSearchStore.clearFilters');
    try {
      return super.clearFilters();
    } finally {
      _$_FilterSearchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showErrors: ${showErrors},
isFilterCount: ${isFilterCount},
getCountFilter: ${getCountFilter},
isFormValid: ${isFormValid}
    ''';
  }
}
