import '../global/constants/api_constants.dart';
import '../network/api_client.dart';
import '../models/addresses.dart';

class AddressesRepository {
  final _api = const ApiClient();

  Future<List<Addresses>> findAll() => _api.getList(
        addressesURL,
        Addresses.fromMap,
        query: {'take': 100},
        errorMessage: 'Erro ao buscar Endereços',
      );
}
