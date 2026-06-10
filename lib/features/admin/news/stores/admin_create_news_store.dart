import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/core/global/injection.dart';
import 'package:rede_campo_online/features/admin/news/screens/widgets/news_media_upload_field.dart';
import 'package:rede_campo_online/core/utils/models/research_areas.dart';
import 'package:rede_campo_online/core/utils/repositories/image_upload_repository.dart';
import 'package:rede_campo_online/core/utils/repositories/research_areas_repository.dart';
import 'package:rede_campo_online/core/utils/stores/user_manager_store.dart';
import 'package:rede_campo_online/features/members/models/members.dart';
import 'package:rede_campo_online/features/news/models/news.dart';
import 'package:rede_campo_online/features/news/models/news_media.dart';
import 'package:rede_campo_online/features/news/repositories/news_media_repository.dart';
import 'package:rede_campo_online/features/news/repositories/news_repository.dart';

part 'admin_create_news_store.g.dart';

class AdminCreateNewsStore = AdminCreateNewsStoreBase
    with _$AdminCreateNewsStore;

abstract class AdminCreateNewsStoreBase with Store {
  AdminCreateNewsStoreBase(this.news) {
    _title = news.title ?? '';
    _description = news.description ?? '';
    _content = news.content ?? '';
    _publicationDate = news.publication_date;
    if (news.research_areas != null) {
      selectedResearchAreas.addAll(news.research_areas!);
    }
    loadResearchAreas();
    if (news.id != null) loadExistingMedia();
  }

  final News news;
  final _repository = NewsRepository();
  final _newsMediaRepository = NewsMediaRepository();
  final _imageUploadRepository = ImageUploadRepository();
  final _researchAreasRepository = ResearchAreasRepository();
  final _userStore = getIt<UserManagerStore>();

  // ── Research Areas ─────────────────────────────────────────────────────────

  final availableResearchAreas = ObservableList<ResearchAreas>();
  final selectedResearchAreas = ObservableList<ResearchAreas>();

  Future<void> loadResearchAreas() async {
    try {
      final areas = await _researchAreasRepository.findAll();
      runInAction(() {
        availableResearchAreas
          ..clear()
          ..addAll(areas);
      });
    } catch (_) {}
  }

  void setResearchAreas(List<ResearchAreas> areas) {
    runInAction(() {
      selectedResearchAreas
        ..clear()
        ..addAll(areas);
    });
  }

  // ── Media ──────────────────────────────────────────────────────────────────

  final pendingMedia = ObservableList<PendingNewsMedia>();

  @action
  void addPendingMedia(XFile file) =>
      pendingMedia.add(PendingNewsMedia(file: file));

  @action
  void removePendingMedia(int index) => pendingMedia.removeAt(index);

  @action
  void setPendingMediaName(int index, String name) =>
      pendingMedia[index].name = name;

  final existingMedia = ObservableList<NewsMedia>();

  @action
  Future<void> loadExistingMedia() async {
    if (news.id == null) return;
    try {
      final media = await _newsMediaRepository.findByNewsId(news.id!);
      existingMedia
        ..clear()
        ..addAll(media);
    } catch (_) {}
  }

  @action
  Future<void> deleteExistingMedia(int index) async {
    final media = existingMedia[index];
    if (media.id == null) return;
    try {
      await _newsMediaRepository.deleteMedia(media.id!);
      existingMedia.removeAt(index);
    } catch (e) {
      setError(e is String ? e : 'Erro ao remover imagem.');
    }
  }

  // ── Form Fields ────────────────────────────────────────────────────────────

  @readonly
  late String _title = '';

  @action
  void setTitle(String value) => _title = value;

  @computed
  bool get titleValid => _title.trim().isNotEmpty && _title.length <= 200;

  String? get titleError {
    if (!showErrors || titleValid) return null;
    if (_title.trim().isEmpty) return 'Campo obrigatório';
    if (_title.length > 200) return 'Máximo de 200 caracteres';
    return null;
  }

  @readonly
  late String _description = '';

  @action
  void setDescription(String value) => _description = value;

  @computed
  bool get descriptionValid =>
      _description.trim().isNotEmpty && _description.length <= 500;

  String? get descriptionError {
    if (!showErrors || descriptionValid) return null;
    if (_description.trim().isEmpty) return 'Campo obrigatório';
    if (_description.length > 500) return 'Máximo de 500 caracteres';
    return null;
  }

  @readonly
  late String _content = '';

  @action
  void setContent(String value) => _content = value;

  @computed
  bool get contentValid => _content.trim().isNotEmpty;

  String? get contentError {
    if (!showErrors || contentValid) return null;
    return 'Campo obrigatório';
  }

  @readonly
  DateTime? _publicationDate;

  @action
  void setPublicationDate(DateTime? value) => _publicationDate = value;

  @computed
  bool get publicationDateValid => _publicationDate != null;

  String? get publicationDateError {
    if (!showErrors || publicationDateValid) return null;
    return 'Campo obrigatório';
  }

  // ── State ──────────────────────────────────────────────────────────────────

  @readonly
  bool _savedOrUpdatedOrDeleted = false;

  @action
  void setSavedOrUpdatedOrDeleted(bool value) =>
      _savedOrUpdatedOrDeleted = value;

  @readonly
  bool _loading = false;

  @action
  void setLoading(bool value) => _loading = value;

  @observable
  String? error;

  @action
  void setError(String? value) => error = value;

  @observable
  bool showErrors = false;

  @action
  void invalidSendPressed() => showErrors = true;

  @computed
  bool get isFormValid =>
      titleValid && descriptionValid && contentValid && publicationDateValid;

  // ── CRUD ───────────────────────────────────────────────────────────────────

  @action
  Future<void> createNews() async {
    setError(null);
    setLoading(true);

    try {
      final newNews = News(
        title: _title.trim(),
        description: _description.trim(),
        content: _content.trim(),
        publication_date: _publicationDate,
        member: Members(id: _userStore.userId),
        research_areas: selectedResearchAreas.toList(),
      );
      final created = await _repository.createNews(newNews);

      if (pendingMedia.isNotEmpty) {
        final newsId = created.id;
        if (newsId == null) {
          throw 'Notícia criada, mas o servidor não retornou o ID. As imagens não foram vinculadas.';
        }
        await _uploadPendingMedia(newsId);
      }

      setSavedOrUpdatedOrDeleted(true);
    } catch (e) {
      setError(e is String ? e : 'Erro ao criar notícia.');
    }

    setLoading(false);
  }

  Future<void> _uploadPendingMedia(int newsId) async {
    for (final item in pendingMedia) {
      final upload = await _imageUploadRepository.uploadImage(
        file: item.file,
        entityType: 'member',
        entityId: _userStore.userId ?? 0,
      );
      await _newsMediaRepository.create(NewsMedia(
        news: News(id: newsId),
        name: item.name.trim().isEmpty ? item.file.name : item.name.trim(),
        media: upload.bestUrl,
      ));
    }
  }

  @action
  Future<void> editNews() async {
    setError(null);
    setLoading(true);

    news.title = _title.trim();
    news.description = _description.trim();
    news.content = _content.trim();
    news.publication_date = _publicationDate;
    news.research_areas = selectedResearchAreas.toList();

    try {
      await _repository.editNews(news);
      if (pendingMedia.isNotEmpty) {
        await _uploadPendingMedia(news.id!);
      }
      setSavedOrUpdatedOrDeleted(true);
    } catch (e) {
      setError(e is String ? e : 'Erro ao editar notícia.');
    }

    setLoading(false);
  }

  @action
  Future<void> deleteNews() async {
    setError(null);
    setLoading(true);

    try {
      await _repository.deleteNews(news.id!.toString());
      setSavedOrUpdatedOrDeleted(true);
    } catch (e) {
      setError(e is String ? e : 'Erro ao deletar notícia.');
    }

    setLoading(false);
  }
}
