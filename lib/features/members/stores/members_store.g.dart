// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'members_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MembersStore on MembersStoreBase, Store {
  Computed<bool>? _$showProgressComputed;

  @override
  bool get showProgress =>
      (_$showProgressComputed ??= Computed<bool>(() => super.showProgress,
              name: 'MembersStoreBase.showProgress'))
          .value;

  late final _$isLoadingAtom =
      Atom(name: 'MembersStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$membersErrorAtom =
      Atom(name: 'MembersStoreBase.membersError', context: context);

  @override
  String? get membersError {
    _$membersErrorAtom.reportRead();
    return super.membersError;
  }

  @override
  set membersError(String? value) {
    _$membersErrorAtom.reportWrite(value, super.membersError, () {
      super.membersError = value;
    });
  }

  late final _$loadMembersAsyncAction =
      AsyncAction('MembersStoreBase.loadMembers', context: context);

  @override
  Future<void> loadMembers() {
    return _$loadMembersAsyncAction.run(() => super.loadMembers());
  }

  late final _$refreshMembersAsyncAction =
      AsyncAction('MembersStoreBase.refreshMembers', context: context);

  @override
  Future<void> refreshMembers() {
    return _$refreshMembersAsyncAction.run(() => super.refreshMembers());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
membersError: ${membersError},
showProgress: ${showProgress}
    ''';
  }
}
