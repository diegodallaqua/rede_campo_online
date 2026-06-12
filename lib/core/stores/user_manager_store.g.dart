// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_manager_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserManagerStore on UserManagerStoreBase, Store {
  Computed<bool>? _$isLoggedInComputed;

  @override
  bool get isLoggedIn =>
      (_$isLoggedInComputed ??= Computed<bool>(() => super.isLoggedIn,
              name: 'UserManagerStoreBase.isLoggedIn'))
          .value;
  Computed<String>? _$userNameComputed;

  @override
  String get userName =>
      (_$userNameComputed ??= Computed<String>(() => super.userName,
              name: 'UserManagerStoreBase.userName'))
          .value;
  Computed<String>? _$userEmailComputed;

  @override
  String get userEmail =>
      (_$userEmailComputed ??= Computed<String>(() => super.userEmail,
              name: 'UserManagerStoreBase.userEmail'))
          .value;
  Computed<int?>? _$userIdComputed;

  @override
  int? get userId => (_$userIdComputed ??= Computed<int?>(() => super.userId,
          name: 'UserManagerStoreBase.userId'))
      .value;
  Computed<String>? _$roleNameComputed;

  @override
  String get roleName =>
      (_$roleNameComputed ??= Computed<String>(() => super.roleName,
              name: 'UserManagerStoreBase.roleName'))
          .value;
  Computed<String>? _$organizationNameComputed;

  @override
  String get organizationName => (_$organizationNameComputed ??=
          Computed<String>(() => super.organizationName,
              name: 'UserManagerStoreBase.organizationName'))
      .value;

  late final _$_authDataAtom =
      Atom(name: 'UserManagerStoreBase._authData', context: context);

  AuthResponse? get authData {
    _$_authDataAtom.reportRead();
    return super._authData;
  }

  @override
  AuthResponse? get _authData => authData;

  @override
  set _authData(AuthResponse? value) {
    _$_authDataAtom.reportWrite(value, super._authData, () {
      super._authData = value;
    });
  }

  late final _$_loadingAtom =
      Atom(name: 'UserManagerStoreBase._loading', context: context);

  bool get loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  bool get _loading => loading;

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  late final _$_errorMessageAtom =
      Atom(name: 'UserManagerStoreBase._errorMessage', context: context);

  String? get errorMessage {
    _$_errorMessageAtom.reportRead();
    return super._errorMessage;
  }

  @override
  String? get _errorMessage => errorMessage;

  @override
  set _errorMessage(String? value) {
    _$_errorMessageAtom.reportWrite(value, super._errorMessage, () {
      super._errorMessage = value;
    });
  }

  late final _$loginAsyncAction =
      AsyncAction('UserManagerStoreBase.login', context: context);

  @override
  Future<bool> login(String email, String password) {
    return _$loginAsyncAction.run(() => super.login(email, password));
  }

  late final _$checkSessionAsyncAction =
      AsyncAction('UserManagerStoreBase.checkSession', context: context);

  @override
  Future<bool> checkSession() {
    return _$checkSessionAsyncAction.run(() => super.checkSession());
  }

  late final _$logoutAsyncAction =
      AsyncAction('UserManagerStoreBase.logout', context: context);

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$UserManagerStoreBaseActionController =
      ActionController(name: 'UserManagerStoreBase', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$UserManagerStoreBaseActionController.startAction(
        name: 'UserManagerStoreBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$UserManagerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setError(String? message) {
    final _$actionInfo = _$UserManagerStoreBaseActionController.startAction(
        name: 'UserManagerStoreBase.setError');
    try {
      return super.setError(message);
    } finally {
      _$UserManagerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$UserManagerStoreBaseActionController.startAction(
        name: 'UserManagerStoreBase.clearError');
    try {
      return super.clearError();
    } finally {
      _$UserManagerStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
userName: ${userName},
userEmail: ${userEmail},
userId: ${userId},
roleName: ${roleName},
organizationName: ${organizationName}
    ''';
  }
}
