import 'package:flutter_test/flutter_test.dart';
import 'package:rede_campo_online/core/stores/paged_store.dart';

/// Store de teste: simula paginação no servidor sobre [total] itens.
class _NumbersStore extends PagedStore<int> {
  _NumbersStore(this.total, {super.peekNextPage})
      : super(pageSize: 3, autoLoad: false);

  final int total;
  final List<int> requestedPages = [];

  @override
  Future<List<int>> fetchPage(int page) async {
    requestedPages.add(page);
    final start = (page - 1) * pageSize;
    if (start >= total) return [];
    final end = (start + pageSize).clamp(0, total);
    return List.generate(end - start, (i) => start + i + 1);
  }
}

Future<void> _settle() => Future<void>.delayed(Duration.zero);

void main() {
  group('PagedStore', () {
    test('does not load when autoLoad is false', () {
      final store = _NumbersStore(10);

      expect(store.requestedPages, isEmpty);
    });

    test('short first page is marked as last page', () async {
      final store = _NumbersStore(2);

      await store.loadData();

      expect(store.list, [1, 2]);
      expect(store.lastPage, isTrue);
      expect(store.lastPageKnown, isTrue);
      expect(store.requestedPages, [1]);
    });

    test('full first page peeks the next page', () async {
      final store = _NumbersStore(6);

      await store.loadData();
      await _settle();

      expect(store.list, [1, 2, 3]);
      expect(store.requestedPages, [1, 2]);
      expect(store.lastPage, isFalse);
      expect(store.lastPageKnown, isTrue);
    });

    test('empty peek marks the current page as last', () async {
      final store = _NumbersStore(3);

      await store.loadData();
      await _settle();

      expect(store.lastPage, isTrue);
      expect(store.lastPageKnown, isTrue);
    });

    test('loadNextPage appends items until the end', () async {
      final store = _NumbersStore(5, peekNextPage: false);
      await store.loadData();

      store.loadNextPage();
      await _settle();

      expect(store.list, [1, 2, 3, 4, 5]);
      expect(store.page, 2);
      expect(store.lastPage, isTrue);
    });

    test('goToPage replaces the list with the target page', () async {
      final store = _NumbersStore(9, peekNextPage: false);
      await store.loadData();

      store.goToPage(3);
      await _settle();

      expect(store.page, 3);
      expect(store.list, [7, 8, 9]);
    });
  });
}
