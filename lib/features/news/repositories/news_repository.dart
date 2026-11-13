import '../../../core/global/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/news.dart';

class NewsRepository {
  final _api = const ApiClient();

  Future<News> createNews(News news) async {
    final map = await _api.post(newsURL, news.toMap(),
        errorMessage: 'Erro ao criar Notícia');
    return map == null ? News() : News.fromMap(map);
  }

  Future<List<News>> findAllNews(
          {int? page = 1, String? search, int take = 15}) =>
      _api.getList(
        newsURL,
        News.fromMap,
        query: {
          'page': page,
          'take': take,
          if (search != null && search.isNotEmpty) 'search': search,
        },
        errorMessage: 'Erro ao buscar Notícias',
      );

  Future<void> editNews(News news) =>
      _api.put('$newsURL${news.id}', news.toMap(),
          errorMessage: 'Erro ao editar Notícia');

  Future<void> deleteNews(String id) =>
      _api.delete('$newsURL$id', errorMessage: 'Erro ao deletar Notícia');
}
