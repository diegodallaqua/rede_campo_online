import 'dart:developer';

import 'package:mobx/mobx.dart';

import 'base_store.dart';

part 'client_paged_store.g.dart';

/// [BaseStore] que baixa a listagem inteira uma vez e pagina e filtra em
/// memória. Subclasses implementam [fetchAll] e [matches].
abstract class ClientPagedStore<T> = ClientPagedStoreBase<T>
    with _$ClientPagedStore<T>;

abstract class ClientPagedStoreBase<T> extends BaseStore<T> with Store {
  ClientPagedStoreBase({required this.pageSize}) {
    loadData();
  }

  final int pageSize;

  List<T> _cache = [];

  String _query = '';

  /// Busca todos os itens no repositório.
  Future<List<T>> fetchAll();

  /// Se [item] corresponde à busca [query] (já em minúsculas).
  bool matches(T item, String query);

  @readonly
  int _page = 1;

  @action
  void setPage(int value) => _page = value;

  @readonly
  bool _lastPage = false;

  @action
  void setLastPage(bool value) => _lastPage = value;

  @computed
  bool get showProgress => loading && list.isEmpty;

  /// Filtra a listagem pelo termo informado e volta à primeira página.
  @action
  void search(String value) {
    _query = value.toLowerCase().trim();
    setPage(1);
    if (_cache.isEmpty) {
      setLastPage(false);
      setData([]);
      loadData();
    } else {
      _applyPage();
    }
  }

  @action
  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 100));
    resetPage();
  }

  @action
  void goToPage(int targetPage) {
    if (loading || targetPage == _page) return;
    setPage(targetPage);
    if (_cache.isNotEmpty) {
      _applyPage();
    } else {
      setLastPage(false);
      setData([]);
      loadData();
    }
  }

  @action
  void resetPage() {
    _cache = [];
    setPage(1);
    setLastPage(false);
    setData([]);
    loadData();
  }

  void _applyPage() {
    final filtered = _query.isEmpty
        ? _cache
        : _cache.where((item) => matches(item, _query)).toList();
    final total = filtered.length;
    final start = ((_page - 1) * pageSize).clamp(0, total);
    final end = (start + pageSize).clamp(0, total);
    setData(filtered.sublist(start, end));
    setLastPage(end >= total);
  }

  Future<void> loadData() async {
    setLoading(true);
    setError(null);
    try {
      if (_cache.isEmpty) _cache = await fetchAll();
      _applyPage();
    } catch (e, s) {
      log('$runtimeType: Erro ao carregar dados (página $_page)',
          error: e.toString(), stackTrace: s);
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
