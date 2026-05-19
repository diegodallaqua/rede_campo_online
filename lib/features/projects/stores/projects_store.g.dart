// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProjectsStore on ProjectsStoreBase, Store {
  Computed<int>? _$itemCountComputed;

  @override
  int get itemCount =>
      (_$itemCountComputed ??= Computed<int>(() => super.itemCount,
              name: 'ProjectsStoreBase.itemCount'))
          .value;
  Computed<bool>? _$showProgressComputed;

  @override
  bool get showProgress =>
      (_$showProgressComputed ??= Computed<bool>(() => super.showProgress,
              name: 'ProjectsStoreBase.showProgress'))
          .value;

  late final _$filterStoreAtom =
      Atom(name: 'ProjectsStoreBase.filterStore', context: context);

  @override
  FilterSearchStore get filterStore {
    _$filterStoreAtom.reportRead();
    return super.filterStore;
  }

  @override
  set filterStore(FilterSearchStore value) {
    _$filterStoreAtom.reportWrite(value, super.filterStore, () {
      super.filterStore = value;
    });
  }

  late final _$_pageAtom =
      Atom(name: 'ProjectsStoreBase._page', context: context);

  int get page {
    _$_pageAtom.reportRead();
    return super._page;
  }

  @override
  int get _page => page;

  @override
  set _page(int value) {
    _$_pageAtom.reportWrite(value, super._page, () {
      super._page = value;
    });
  }

  late final _$_lastPageAtom =
      Atom(name: 'ProjectsStoreBase._lastPage', context: context);

  bool get lastPage {
    _$_lastPageAtom.reportRead();
    return super._lastPage;
  }

  @override
  bool get _lastPage => lastPage;

  @override
  set _lastPage(bool value) {
    _$_lastPageAtom.reportWrite(value, super._lastPage, () {
      super._lastPage = value;
    });
  }

  late final _$refreshDataAsyncAction =
      AsyncAction('ProjectsStoreBase.refreshData', context: context);

  @override
  Future<void> refreshData() {
    return _$refreshDataAsyncAction.run(() => super.refreshData());
  }

  late final _$ProjectsStoreBaseActionController =
      ActionController(name: 'ProjectsStoreBase', context: context);

  @override
  void setFilter(FilterSearchStore value) {
    final _$actionInfo = _$ProjectsStoreBaseActionController.startAction(
        name: 'ProjectsStoreBase.setFilter');
    try {
      return super.setFilter(value);
    } finally {
      _$ProjectsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPage(int value) {
    final _$actionInfo = _$ProjectsStoreBaseActionController.startAction(
        name: 'ProjectsStoreBase.setPage');
    try {
      return super.setPage(value);
    } finally {
      _$ProjectsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLastPage(bool value) {
    final _$actionInfo = _$ProjectsStoreBaseActionController.startAction(
        name: 'ProjectsStoreBase.setLastPage');
    try {
      return super.setLastPage(value);
    } finally {
      _$ProjectsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadNextPage() {
    final _$actionInfo = _$ProjectsStoreBaseActionController.startAction(
        name: 'ProjectsStoreBase.loadNextPage');
    try {
      return super.loadNextPage();
    } finally {
      _$ProjectsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _addNewItems(List<Projects> newItems) {
    final _$actionInfo = _$ProjectsStoreBaseActionController.startAction(
        name: 'ProjectsStoreBase._addNewItems');
    try {
      return super._addNewItems(newItems);
    } finally {
      _$ProjectsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
filterStore: ${filterStore},
itemCount: ${itemCount},
showProgress: ${showProgress}
    ''';
  }
}
