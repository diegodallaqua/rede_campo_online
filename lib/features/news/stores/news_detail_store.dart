import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../models/news_media.dart';
import '../repositories/news_media_repository.dart';

part 'news_detail_store.g.dart';

class NewsDetailStore = NewsDetailStoreBase with _$NewsDetailStore;

abstract class NewsDetailStoreBase with Store {
  final NewsMediaRepository _mediaRepository = NewsMediaRepository();
  final int newsId;

  NewsDetailStoreBase({required this.newsId}) {
    loadMedia();
  }

  @readonly
  ObservableList<NewsMedia> _media = ObservableList<NewsMedia>();

  @readonly
  bool _mediaLoading = false;

  @readonly
  String? _mediaError;

  @action
  Future<void> loadMedia() async {
    _mediaLoading = true;
    _mediaError = null;
    try {
      final all = await _mediaRepository.findAll();
      _media
        ..clear()
        ..addAll(all.where((m) => m.news?.id == newsId));
    } catch (e, s) {
      log(
        'NewsDetailStore: Erro ao carregar mídia da notícia $newsId',
        error: e,
        stackTrace: s,
      );
      _mediaError = e.toString();
    } finally {
      _mediaLoading = false;
    }
  }

  Future<void> refreshMedia() => loadMedia();
}
