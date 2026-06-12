import 'dart:developer';

import 'package:mobx/mobx.dart';

/// Carrega todas as mídias de uma entidade e as indexa pelo id do dono
/// (primeira mídia de cada um), padrão usado nas listagens administrativas
/// de eventos, notícias e projetos.
///
/// Implementado com MobX "puro" (sem codegen) por ser pequeno e genérico.
class MediaMapStore<M> {
  MediaMapStore({
    required this.fetchAll,
    required this.ownerId,
    this.logLabel = 'MediaMapStore',
  });

  /// Busca todas as mídias no repositório.
  final Future<List<M>> Function() fetchAll;

  /// Extrai o id da entidade dona da mídia (ex.: `media.event?.id`).
  final int? Function(M media) ownerId;

  final String logLabel;

  final ObservableMap<int, M> map = ObservableMap<int, M>();

  final Observable<bool> _loading = Observable(false);
  final Observable<String?> _error = Observable<String?>(null);

  bool get loading => _loading.value;
  String? get error => _error.value;

  Future<void> load() async {
    runInAction(() {
      _loading.value = true;
      _error.value = null;
    });
    try {
      final mediaList = await fetchAll();
      final newMap = <int, M>{};
      for (final m in mediaList) {
        final id = ownerId(m);
        if (id != null && !newMap.containsKey(id)) {
          newMap[id] = m;
        }
      }
      runInAction(() {
        map
          ..clear()
          ..addAll(newMap);
      });
    } catch (e, s) {
      log(
        '$logLabel: Erro ao carregar mídias',
        error: e.toString(),
        stackTrace: s,
      );
      runInAction(() => _error.value = e.toString());
    } finally {
      runInAction(() => _loading.value = false);
    }
  }
}
