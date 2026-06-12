import 'package:mobx/mobx.dart';

part 'base_store.g.dart';

class BaseStore<T> = _BaseStore<T> with _$BaseStore;

abstract class _BaseStore<T> with Store {
  @observable
  bool _loading = false;

  @observable
  String? _error;

  @observable
  ObservableList<T> _list = ObservableList<T>();

  @computed
  bool get loading => _loading;

  @computed
  String? get error => _error;

  @computed
  ObservableList<T> get list => _list;

  @action
  void setLoading(bool value) {
    _loading = value;
  }

  @action
  void setError(String? message) {
    _error = message;
  }

  @action
  void setData(List<T> newData) {
    _list.clear();
    _list.addAll(newData);
  }

  @action
  Future<void> fetchData(Future<List<T>> Function() fetchFunction) async {
    setLoading(true);
    setError(null);

    try {
      final newData = await fetchFunction();
      setData(newData);
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
