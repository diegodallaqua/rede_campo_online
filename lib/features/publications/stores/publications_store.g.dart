// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publications_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PublicationsStore on PublicationsStoreBase, Store {
  Computed<int>? _$itemCountComputed;

  @override
  int get itemCount =>
      (_$itemCountComputed ??= Computed<int>(() => super.itemCount,
              name: 'PublicationsStoreBase.itemCount'))
          .value;
  Computed<bool>? _$showProgressComputed;

  @override
  bool get showProgress =>
      (_$showProgressComputed ??= Computed<bool>(() => super.showProgress,
              name: 'PublicationsStoreBase.showProgress'))
          .value;
  Computed<bool>? _$showRecentProgressComputed;

  @override
  bool get showRecentProgress => (_$showRecentProgressComputed ??=
          Computed<bool>(() => super.showRecentProgress,
              name: 'PublicationsStoreBase.showRecentProgress'))
      .value;

  late final _$filterStoreAtom =
      Atom(name: 'PublicationsStoreBase.filterStore', context: context);

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
      Atom(name: 'PublicationsStoreBase._page', context: context);

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
      Atom(name: 'PublicationsStoreBase._lastPage', context: context);

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

  late final _$recentPublicationsAtom =
      Atom(name: 'PublicationsStoreBase.recentPublications', context: context);

  @override
  ObservableList<Publications> get recentPublications {
    _$recentPublicationsAtom.reportRead();
    return super.recentPublications;
  }

  @override
  set recentPublications(ObservableList<Publications> value) {
    _$recentPublicationsAtom.reportWrite(value, super.recentPublications, () {
      super.recentPublications = value;
    });
  }

  late final _$isLoadingRecentAtom =
      Atom(name: 'PublicationsStoreBase.isLoadingRecent', context: context);

  @override
  bool get isLoadingRecent {
    _$isLoadingRecentAtom.reportRead();
    return super.isLoadingRecent;
  }

  @override
  set isLoadingRecent(bool value) {
    _$isLoadingRecentAtom.reportWrite(value, super.isLoadingRecent, () {
      super.isLoadingRecent = value;
    });
  }

  late final _$recentPublicationsErrorAtom = Atom(
      name: 'PublicationsStoreBase.recentPublicationsError', context: context);

  @override
  String? get recentPublicationsError {
    _$recentPublicationsErrorAtom.reportRead();
    return super.recentPublicationsError;
  }

  @override
  set recentPublicationsError(String? value) {
    _$recentPublicationsErrorAtom
        .reportWrite(value, super.recentPublicationsError, () {
      super.recentPublicationsError = value;
    });
  }

  late final _$refreshDataAsyncAction =
      AsyncAction('PublicationsStoreBase.refreshData', context: context);

  @override
  Future<void> refreshData() {
    return _$refreshDataAsyncAction.run(() => super.refreshData());
  }

  late final _$loadRecentPublicationsAsyncAction = AsyncAction(
      'PublicationsStoreBase.loadRecentPublications',
      context: context);

  @override
  Future<void> loadRecentPublications({int limit = 10}) {
    return _$loadRecentPublicationsAsyncAction
        .run(() => super.loadRecentPublications(limit: limit));
  }

  late final _$refreshRecentPublicationsAsyncAction = AsyncAction(
      'PublicationsStoreBase.refreshRecentPublications',
      context: context);

  @override
  Future<void> refreshRecentPublications({int limit = 5}) {
    return _$refreshRecentPublicationsAsyncAction
        .run(() => super.refreshRecentPublications(limit: limit));
  }

  late final _$PublicationsStoreBaseActionController =
      ActionController(name: 'PublicationsStoreBase', context: context);

  @override
  void setFilter(FilterSearchStore value) {
    final _$actionInfo = _$PublicationsStoreBaseActionController.startAction(
        name: 'PublicationsStoreBase.setFilter');
    try {
      return super.setFilter(value);
    } finally {
      _$PublicationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPage(int value) {
    final _$actionInfo = _$PublicationsStoreBaseActionController.startAction(
        name: 'PublicationsStoreBase.setPage');
    try {
      return super.setPage(value);
    } finally {
      _$PublicationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLastPage(bool value) {
    final _$actionInfo = _$PublicationsStoreBaseActionController.startAction(
        name: 'PublicationsStoreBase.setLastPage');
    try {
      return super.setLastPage(value);
    } finally {
      _$PublicationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadNextPage() {
    final _$actionInfo = _$PublicationsStoreBaseActionController.startAction(
        name: 'PublicationsStoreBase.loadNextPage');
    try {
      return super.loadNextPage();
    } finally {
      _$PublicationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _addNewItems(List<Publications> newItems) {
    final _$actionInfo = _$PublicationsStoreBaseActionController.startAction(
        name: 'PublicationsStoreBase._addNewItems');
    try {
      return super._addNewItems(newItems);
    } finally {
      _$PublicationsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
filterStore: ${filterStore},
recentPublications: ${recentPublications},
isLoadingRecent: ${isLoadingRecent},
recentPublicationsError: ${recentPublicationsError},
itemCount: ${itemCount},
showProgress: ${showProgress},
showRecentProgress: ${showRecentProgress}
    ''';
  }
}
