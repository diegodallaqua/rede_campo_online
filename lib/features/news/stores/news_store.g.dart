// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewsStore on NewsStoreBase, Store {
  Computed<int>? _$itemCountComputed;

  @override
  int get itemCount => (_$itemCountComputed ??=
          Computed<int>(() => super.itemCount, name: 'NewsStoreBase.itemCount'))
      .value;
  Computed<bool>? _$showProgressComputed;

  @override
  bool get showProgress =>
      (_$showProgressComputed ??= Computed<bool>(() => super.showProgress,
              name: 'NewsStoreBase.showProgress'))
          .value;
  Computed<bool>? _$showRecentProgressComputed;

  @override
  bool get showRecentProgress => (_$showRecentProgressComputed ??=
          Computed<bool>(() => super.showRecentProgress,
              name: 'NewsStoreBase.showRecentProgress'))
      .value;

  late final _$filterStoreAtom =
      Atom(name: 'NewsStoreBase.filterStore', context: context);

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

  late final _$_pageAtom = Atom(name: 'NewsStoreBase._page', context: context);

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
      Atom(name: 'NewsStoreBase._lastPage', context: context);

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

  late final _$recentNewsAtom =
      Atom(name: 'NewsStoreBase.recentNews', context: context);

  @override
  ObservableList<News> get recentNews {
    _$recentNewsAtom.reportRead();
    return super.recentNews;
  }

  @override
  set recentNews(ObservableList<News> value) {
    _$recentNewsAtom.reportWrite(value, super.recentNews, () {
      super.recentNews = value;
    });
  }

  late final _$isLoadingRecentAtom =
      Atom(name: 'NewsStoreBase.isLoadingRecent', context: context);

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

  late final _$recentNewsErrorAtom =
      Atom(name: 'NewsStoreBase.recentNewsError', context: context);

  @override
  String? get recentNewsError {
    _$recentNewsErrorAtom.reportRead();
    return super.recentNewsError;
  }

  @override
  set recentNewsError(String? value) {
    _$recentNewsErrorAtom.reportWrite(value, super.recentNewsError, () {
      super.recentNewsError = value;
    });
  }

  late final _$mediaMapAtom =
      Atom(name: 'NewsStoreBase.mediaMap', context: context);

  @override
  ObservableMap<int, NewsMedia> get mediaMap {
    _$mediaMapAtom.reportRead();
    return super.mediaMap;
  }

  @override
  set mediaMap(ObservableMap<int, NewsMedia> value) {
    _$mediaMapAtom.reportWrite(value, super.mediaMap, () {
      super.mediaMap = value;
    });
  }

  late final _$loadingMediaAtom =
      Atom(name: 'NewsStoreBase.loadingMedia', context: context);

  @override
  bool get loadingMedia {
    _$loadingMediaAtom.reportRead();
    return super.loadingMedia;
  }

  @override
  set loadingMedia(bool value) {
    _$loadingMediaAtom.reportWrite(value, super.loadingMedia, () {
      super.loadingMedia = value;
    });
  }

  late final _$errorMediaAtom =
      Atom(name: 'NewsStoreBase.errorMedia', context: context);

  @override
  String? get errorMedia {
    _$errorMediaAtom.reportRead();
    return super.errorMedia;
  }

  @override
  set errorMedia(String? value) {
    _$errorMediaAtom.reportWrite(value, super.errorMedia, () {
      super.errorMedia = value;
    });
  }

  late final _$refreshDataAsyncAction =
      AsyncAction('NewsStoreBase.refreshData', context: context);

  @override
  Future<void> refreshData() {
    return _$refreshDataAsyncAction.run(() => super.refreshData());
  }

  late final _$loadRecentNewsAsyncAction =
      AsyncAction('NewsStoreBase.loadRecentNews', context: context);

  @override
  Future<void> loadRecentNews({int limit = 10}) {
    return _$loadRecentNewsAsyncAction
        .run(() => super.loadRecentNews(limit: limit));
  }

  late final _$refreshRecentNewsAsyncAction =
      AsyncAction('NewsStoreBase.refreshRecentNews', context: context);

  @override
  Future<void> refreshRecentNews({int limit = 5}) {
    return _$refreshRecentNewsAsyncAction
        .run(() => super.refreshRecentNews(limit: limit));
  }

  late final _$NewsStoreBaseActionController =
      ActionController(name: 'NewsStoreBase', context: context);

  @override
  void setFilter(FilterSearchStore value) {
    final _$actionInfo = _$NewsStoreBaseActionController.startAction(
        name: 'NewsStoreBase.setFilter');
    try {
      return super.setFilter(value);
    } finally {
      _$NewsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPage(int value) {
    final _$actionInfo = _$NewsStoreBaseActionController.startAction(
        name: 'NewsStoreBase.setPage');
    try {
      return super.setPage(value);
    } finally {
      _$NewsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLastPage(bool value) {
    final _$actionInfo = _$NewsStoreBaseActionController.startAction(
        name: 'NewsStoreBase.setLastPage');
    try {
      return super.setLastPage(value);
    } finally {
      _$NewsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadNextPage() {
    final _$actionInfo = _$NewsStoreBaseActionController.startAction(
        name: 'NewsStoreBase.loadNextPage');
    try {
      return super.loadNextPage();
    } finally {
      _$NewsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _addNewItems(List<News> newItems) {
    final _$actionInfo = _$NewsStoreBaseActionController.startAction(
        name: 'NewsStoreBase._addNewItems');
    try {
      return super._addNewItems(newItems);
    } finally {
      _$NewsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setLoadingMedia(bool value) {
    final _$actionInfo = _$NewsStoreBaseActionController.startAction(
        name: 'NewsStoreBase._setLoadingMedia');
    try {
      return super._setLoadingMedia(value);
    } finally {
      _$NewsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setErrorMedia(String? value) {
    final _$actionInfo = _$NewsStoreBaseActionController.startAction(
        name: 'NewsStoreBase._setErrorMedia');
    try {
      return super._setErrorMedia(value);
    } finally {
      _$NewsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setMediaData(Map<int, NewsMedia> data) {
    final _$actionInfo = _$NewsStoreBaseActionController.startAction(
        name: 'NewsStoreBase._setMediaData');
    try {
      return super._setMediaData(data);
    } finally {
      _$NewsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
filterStore: ${filterStore},
recentNews: ${recentNews},
isLoadingRecent: ${isLoadingRecent},
recentNewsError: ${recentNewsError},
mediaMap: ${mediaMap},
loadingMedia: ${loadingMedia},
errorMedia: ${errorMedia},
itemCount: ${itemCount},
showProgress: ${showProgress},
showRecentProgress: ${showRecentProgress}
    ''';
  }
}
