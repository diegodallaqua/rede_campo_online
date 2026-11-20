import 'package:flutter_test/flutter_test.dart';
import 'package:rede_campo_online/core/stores/client_paged_store.dart';

/// Store de teste: lista de nomes fixa, busca por substring.
class _NamesStore extends ClientPagedStore<String> {
  _NamesStore(this.items) : super(pageSize: 2);

  final List<String> items;
  int fetchCount = 0;

  @override
  Future<List<String>> fetchAll() async {
    fetchCount++;
    return items;
  }

  @override
  bool matches(String item, String query) => item.toLowerCase().contains(query);
}

/// Aguarda o `loadData` disparado no construtor terminar.
Future<void> _settle() => Future<void>.delayed(Duration.zero);

void main() {
  const names = ['Ana', 'Bruno', 'Carla', 'Daniel', 'Elisa'];

  group('ClientPagedStore', () {
    test('loads the first page on creation', () async {
      final store = _NamesStore(names);
      await _settle();

      expect(store.list, ['Ana', 'Bruno']);
      expect(store.page, 1);
      expect(store.lastPage, isFalse);
      expect(store.loading, isFalse);
    });

    test('goToPage slices the cache without fetching again', () async {
      final store = _NamesStore(names);
      await _settle();

      store.goToPage(3);

      expect(store.list, ['Elisa']);
      expect(store.lastPage, isTrue);
      expect(store.fetchCount, 1);
    });

    test('search filters case-insensitively and resets to page 1', () async {
      final store = _NamesStore(names);
      await _settle();
      store.goToPage(2);

      store.search('  AN ');

      expect(store.page, 1);
      expect(store.list, ['Ana', 'Daniel']);
      expect(store.lastPage, isTrue);
    });

    test('search with no matches yields an empty last page', () async {
      final store = _NamesStore(names);
      await _settle();

      store.search('zzz');

      expect(store.list, isEmpty);
      expect(store.lastPage, isTrue);
    });

    test('resetPage drops the cache and fetches again', () async {
      final store = _NamesStore(names);
      await _settle();

      store.resetPage();
      await _settle();

      expect(store.fetchCount, 2);
      expect(store.list, ['Ana', 'Bruno']);
    });

    test('records the error when fetchAll fails', () async {
      final store = _FailingStore();
      await _settle();

      expect(store.error, contains('offline'));
      expect(store.loading, isFalse);
      expect(store.list, isEmpty);
    });
  });
}

class _FailingStore extends ClientPagedStore<String> {
  _FailingStore() : super(pageSize: 2);

  @override
  Future<List<String>> fetchAll() async => throw Exception('offline');

  @override
  bool matches(String item, String query) => true;
}
