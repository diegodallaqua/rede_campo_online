import 'package:flutter_test/flutter_test.dart';
import 'package:rede_campo_online/core/stores/base_store.dart';

void main() {
  group('BaseStore.fetchData', () {
    test('fills the list and clears loading on success', () async {
      final store = BaseStore<int>();

      await store.fetchData(() async => [1, 2, 3]);

      expect(store.list, [1, 2, 3]);
      expect(store.loading, isFalse);
      expect(store.error, isNull);
    });

    test('replaces previous data instead of appending', () async {
      final store = BaseStore<int>()..setData([9, 9]);

      await store.fetchData(() async => [1]);

      expect(store.list, [1]);
    });

    test('stores the error message and clears loading on failure', () async {
      final store = BaseStore<int>();

      await store.fetchData(() async => throw Exception('boom'));

      expect(store.error, contains('boom'));
      expect(store.loading, isFalse);
    });

    test('clears a previous error on a new successful fetch', () async {
      final store = BaseStore<int>()..setError('old');

      await store.fetchData(() async => [1]);

      expect(store.error, isNull);
    });
  });
}
