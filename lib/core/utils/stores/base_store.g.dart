// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BaseStore<T> on _BaseStore<T>, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_BaseStore.loading'))
      .value;
  Computed<String?>? _$errorComputed;

  @override
  String? get error => (_$errorComputed ??=
          Computed<String?>(() => super.error, name: '_BaseStore.error'))
      .value;
  Computed<ObservableList<T>>? _$listComputed;

  @override
  ObservableList<T> get list =>
      (_$listComputed ??= Computed<ObservableList<T>>(() => super.list,
              name: '_BaseStore.list'))
          .value;

  late final _$_loadingAtom =
      Atom(name: '_BaseStore._loading', context: context);

  @override
  bool get _loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  late final _$_errorAtom = Atom(name: '_BaseStore._error', context: context);

  @override
  String? get _error {
    _$_errorAtom.reportRead();
    return super._error;
  }

  @override
  set _error(String? value) {
    _$_errorAtom.reportWrite(value, super._error, () {
      super._error = value;
    });
  }

  late final _$_listAtom = Atom(name: '_BaseStore._list', context: context);

  @override
  ObservableList<T> get _list {
    _$_listAtom.reportRead();
    return super._list;
  }

  @override
  set _list(ObservableList<T> value) {
    _$_listAtom.reportWrite(value, super._list, () {
      super._list = value;
    });
  }

  late final _$fetchDataAsyncAction =
      AsyncAction('_BaseStore.fetchData', context: context);

  @override
  Future<void> fetchData(
      String cacheKey, Future<List<T>> Function() fetchFunction) {
    return _$fetchDataAsyncAction
        .run(() => super.fetchData(cacheKey, fetchFunction));
  }

  late final _$saveItemAsyncAction =
      AsyncAction('_BaseStore.saveItem', context: context);

  @override
  Future<R> saveItem<R>(String cacheType, Future<R> Function() saveFunction,
      {String? itemId}) {
    return _$saveItemAsyncAction
        .run(() => super.saveItem<R>(cacheType, saveFunction, itemId: itemId));
  }

  late final _$deleteItemAsyncAction =
      AsyncAction('_BaseStore.deleteItem', context: context);

  @override
  Future<R> deleteItem<R>(
      String cacheType, String itemId, Future<R> Function() deleteFunction) {
    return _$deleteItemAsyncAction
        .run(() => super.deleteItem<R>(cacheType, itemId, deleteFunction));
  }

  late final _$bulkOperationAsyncAction =
      AsyncAction('_BaseStore.bulkOperation', context: context);

  @override
  Future<R> bulkOperation<R>(List<String> cacheTypes, String operation,
      Future<R> Function() operationFunction,
      {int? affectedCount}) {
    return _$bulkOperationAsyncAction.run(() => super.bulkOperation<R>(
        cacheTypes, operation, operationFunction,
        affectedCount: affectedCount));
  }

  late final _$_BaseStoreActionController =
      ActionController(name: '_BaseStore', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo =
        _$_BaseStoreActionController.startAction(name: '_BaseStore.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_BaseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? message) {
    final _$actionInfo =
        _$_BaseStoreActionController.startAction(name: '_BaseStore.setError');
    try {
      return super.setError(message);
    } finally {
      _$_BaseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setData(List<T> newData) {
    final _$actionInfo =
        _$_BaseStoreActionController.startAction(name: '_BaseStore.setData');
    try {
      return super.setData(newData);
    } finally {
      _$_BaseStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
error: ${error},
list: ${list}
    ''';
  }
}
