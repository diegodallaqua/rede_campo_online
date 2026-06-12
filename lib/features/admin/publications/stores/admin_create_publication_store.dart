import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/core/global/injection.dart';
import 'package:rede_campo_online/core/models/contributor.dart';
import 'package:rede_campo_online/core/models/contributor_roles.dart';
import 'package:rede_campo_online/core/models/organizations.dart';
import 'package:rede_campo_online/core/models/research_areas.dart';
import 'package:rede_campo_online/core/repositories/contributor_roles_repository.dart';
import 'package:rede_campo_online/core/repositories/contributors_repository.dart';
import 'package:rede_campo_online/core/repositories/external_authors_repository.dart';
import 'package:rede_campo_online/core/repositories/image_upload_repository.dart';
import 'package:rede_campo_online/core/repositories/organizations_repository.dart';
import 'package:rede_campo_online/core/repositories/research_areas_repository.dart';
import 'package:rede_campo_online/core/stores/filter_search_store.dart';
import 'package:rede_campo_online/core/stores/user_manager_store.dart';
import 'package:rede_campo_online/features/admin/publications/models/publication_type.dart';
import 'package:rede_campo_online/features/articles/models/articles.dart';
import 'package:rede_campo_online/features/articles/repositories/articles_repository.dart';
import 'package:rede_campo_online/features/book_chapters/models/book_chapters.dart';
import 'package:rede_campo_online/features/book_chapters/repositories/book_chapters_repository.dart';
import 'package:rede_campo_online/features/books/models/books.dart';
import 'package:rede_campo_online/features/books/repositories/books_repository.dart';
import 'package:rede_campo_online/features/members/models/members.dart';
import 'package:rede_campo_online/features/members/repositories/members_repository.dart';
import 'package:rede_campo_online/features/publications/models/publications.dart';
import 'package:rede_campo_online/features/publications/repositories/publications_repository.dart';
import 'package:rede_campo_online/features/thesis/models/thesis.dart';
import 'package:rede_campo_online/features/thesis/repositories/thesis_repository.dart';

part 'admin_create_publication_store.g.dart';

class AdminCreatePublicationStore = AdminCreatePublicationStoreBase
    with _$AdminCreatePublicationStore;

abstract class AdminCreatePublicationStoreBase with Store {
  AdminCreatePublicationStoreBase(this.publication) {
    _title = publication.title ?? '';
    _abstract = publication.abstract ?? '';
    _doi = publication.doi ?? '';
    _publicationDate = publication.publication_date;
    if (publication.research_areas != null) {
      selectedResearchAreas.addAll(publication.research_areas!);
    }
    if (publication.contributors != null) {
      contributors.addAll(publication.contributors!);
      _originalContributors.addAll(publication.contributors!);
    }
    loadResearchAreas();
    loadMembers();
    loadContributorRoles();
    loadOrganizations();
    if (editing) {
      // O tipo e seus atributos chegam inline em `details`; se ausentes
      // (formato antigo), recai para a detecção via endpoints de tipo.
      if (publication.publication_type != null) {
        _applyTypeFromPublication();
      } else {
        loadPublicationType();
      }
    }
  }

  final Publications publication;
  final _repository = PublicationsRepository();
  final _articlesRepository = ArticlesRepository();
  final _booksRepository = BooksRepository();
  final _bookChaptersRepository = BookChaptersRepository();
  final _thesisRepository = ThesisRepository();
  final _contributorsRepository = ContributorsRepository();
  final _externalAuthorsRepository = ExternalAuthorsRepository();
  final _contributorRolesRepository = ContributorRolesRepository();
  final _organizationsRepository = OrganizationsRepository();
  final _researchAreasRepository = ResearchAreasRepository();
  final _membersRepository = MembersRepository();
  final _imageUploadRepository = ImageUploadRepository();
  final _userStore = getIt<UserManagerStore>();
  final _organizationsList = ObservableList<Organizations>();

  bool get editing => publication.id != null;

  // Catálogos carregados da API
  final availableResearchAreas = ObservableList<ResearchAreas>();
  final selectedResearchAreas = ObservableList<ResearchAreas>();
  final availableMembers = ObservableList<Members>();
  final availableContributorRoles = ObservableList<ContributorRoles>();

  ObservableList<Organizations> get availableOrganizations =>
      _organizationsList;

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

  Future<void> loadMembers() async {
    try {
      final members = await _membersRepository.findAllMembers();
      runInAction(() {
        availableMembers
          ..clear()
          ..addAll(members);
      });
    } catch (_) {}
  }

  Future<void> loadContributorRoles() async {
    try {
      final roles = await _contributorRolesRepository.findAll();
      runInAction(() {
        availableContributorRoles
          ..clear()
          ..addAll(roles);
      });
    } catch (_) {}
  }

  Future<void> loadOrganizations() async {
    try {
      final organizations = await _organizationsRepository.findAll();
      runInAction(() {
        _organizationsList
          ..clear()
          ..addAll(organizations);
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

  // Contribuidores — os já persistidos chegam com id; os novos são criados
  // junto com o salvamento (autor externo antes do contribuidor).
  final contributors = ObservableList<Contributors>();
  final _originalContributors = <Contributors>[];

  @action
  void addContributor(Contributors contributor) =>
      contributors.add(contributor);

  @action
  void removeContributor(int index) => contributors.removeAt(index);

  @readonly
  late String _title = '';

  @action
  void setTitle(String value) => _title = value;

  @computed
  bool get titleValid => _title.trim().isNotEmpty && _title.length <= 500;

  String? get titleError {
    if (!showErrors || titleValid) return null;
    if (_title.trim().isEmpty) return 'Campo obrigatório';
    if (_title.length > 500) return 'Máximo de 500 caracteres';
    return null;
  }

  @readonly
  late String _abstract = '';

  @action
  void setAbstract(String value) => _abstract = value;

  @computed
  bool get abstractValid => _abstract.trim().isNotEmpty;

  String? get abstractError {
    if (!showErrors || abstractValid) return null;
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

  @readonly
  late String _doi = '';

  @action
  void setDoi(String value) => _doi = value;

  // Opcional; quando preenchido exige o formato padrão de DOI (10.xxxx/...),
  // evitando que valores arbitrários sejam publicados como identificador.
  @computed
  bool get doiValid {
    final value = _doi.trim();
    if (value.isEmpty) return true;
    return RegExp(r'^10\.\d{4,9}/\S+$', caseSensitive: false).hasMatch(value);
  }

  String? get doiError {
    if (!showErrors || doiValid) return null;
    return 'Informe um DOI válido (ex.: 10.1000/xyz123)';
  }

  // Tipo da publicação. Na criação é escolhido pelo usuário; na edição é
  // detectado a partir do registro de tipo já existente e não pode ser trocado.
  @readonly
  PublicationType? _publicationType;

  @action
  void setPublicationType(PublicationType? value) => _publicationType = value;

  @readonly
  bool _loadingType = false;

  @action
  void _setLoadingType(bool value) => _loadingType = value;

  /// Descobre o tipo da publicação em edição. Tenta primeiro o GET direto por
  /// id de publicação em cada endpoint de tipo; se nenhum responder, recai para
  /// uma varredura das listagens (filtradas pelo título) casando o id.
  @action
  Future<void> loadPublicationType() async {
    final id = publication.id;
    if (id == null) return;
    _setLoadingType(true);

    try {
      final article = await _articlesRepository.findByPublicationId(id);
      if (article != null) {
        _applyArticle(article);
        _setLoadingType(false);
        return;
      }

      final book = await _booksRepository.findByPublicationId(id);
      if (book != null) {
        _applyBook(book);
        _setLoadingType(false);
        return;
      }

      final chapter = await _bookChaptersRepository.findByPublicationId(id);
      if (chapter != null) {
        _applyBookChapter(chapter);
        _setLoadingType(false);
        return;
      }

      final thesis = await _thesisRepository.findByPublicationId(id);
      if (thesis != null) {
        _applyThesis(thesis);
        _setLoadingType(false);
        return;
      }

      // Fallback: varre as listagens caso o GET por id não exista no backend.
      if (await _detectTypeFromListings(id)) {
        _setLoadingType(false);
        return;
      }
    } catch (_) {}

    _setLoadingType(false);
  }

  Future<bool> _detectTypeFromListings(int id) async {
    final filter = FilterSearchStore()..setSearch(publication.title ?? '');
    try {
      final articles = await _articlesRepository.findAllArticles(
          filterSearchStore: filter, take: 100);
      for (final a in articles) {
        if (a.publication?.id == id) {
          _applyArticle(a);
          return true;
        }
      }

      final books = await _booksRepository.findAllBooks(
          filterSearchStore: filter, take: 100);
      for (final b in books) {
        if (b.publication?.id == id) {
          _applyBook(b);
          return true;
        }
      }

      final chapters = await _bookChaptersRepository.findAllBookChapters(
          filterSearchStore: filter, take: 100);
      for (final c in chapters) {
        if (c.publication?.id == id) {
          _applyBookChapter(c);
          return true;
        }
      }

      final theses = await _thesisRepository.findAllThesis(
          filterSearchStore: filter, take: 100);
      for (final t in theses) {
        if (t.publication?.id == id) {
          _applyThesis(t);
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  PublicationType? _typeFromString(String? value) {
    switch (value) {
      case 'article':
        return PublicationType.article;
      case 'book':
        return PublicationType.book;
      case 'book_chapter':
        return PublicationType.bookChapter;
      case 'thesis':
        return PublicationType.thesis;
    }
    return null;
  }

  /// Aplica o tipo e os atributos vindos inline em `details`.
  @action
  void _applyTypeFromPublication() {
    final type = _typeFromString(publication.publication_type);
    if (type == null) return;
    final d = publication.details ?? const {};
    _publicationType = type;

    switch (type) {
      case PublicationType.article:
        _journalName = (d['journal_name'] ?? '').toString();
        _volume = (d['volume'] ?? '').toString();
        _issue = (d['issue'] ?? '').toString();
        _pages = (d['pages'] ?? '').toString();
        _articlePublisher = (d['publisher'] ?? '').toString();
      case PublicationType.book:
        _bookPublisher = (d['publisher'] ?? '').toString();
        _edition = (d['edition'] ?? '').toString();
        _existingCoverPhoto = (d['cover_photo'] ?? '').toString();
        _isbn = (d['isbn'] ?? '').toString();
        _bookUrl = (d['book_url'] ?? '').toString();
      case PublicationType.bookChapter:
        _bookName = (d['book_name'] ?? '').toString();
        _chapterNumber = d['chapter_number']?.toString() ?? '';
      case PublicationType.thesis:
        _organization = d['organization'] is Map
            ? Organizations.fromMap(
                Map<String, dynamic>.from(d['organization']))
            : null;
        _numberOfPages = d['number_of_pages']?.toString() ?? '';
    }
  }

  @action
  void _applyArticle(Articles a) {
    _publicationType = PublicationType.article;
    _journalName = a.journal_name ?? '';
    _volume = a.volume ?? '';
    _issue = a.issue ?? '';
    _pages = a.pages ?? '';
    _articlePublisher = a.publisher ?? '';
  }

  @action
  void _applyBook(Books b) {
    _publicationType = PublicationType.book;
    _bookPublisher = b.publisher ?? '';
    _edition = b.edition ?? '';
    _existingCoverPhoto = b.cover_photo ?? '';
    _isbn = b.isbn ?? '';
    _bookUrl = b.book_url ?? '';
  }

  @action
  void _applyBookChapter(BookChapters c) {
    _publicationType = PublicationType.bookChapter;
    _bookName = c.book_name ?? '';
    _chapterNumber = c.chapter_number?.toString() ?? '';
  }

  @action
  void _applyThesis(Thesis t) {
    _publicationType = PublicationType.thesis;
    _organization = t.organization;
    _numberOfPages = t.number_of_pages?.toString() ?? '';
  }

  @computed
  bool get publicationTypeValid => editing || _publicationType != null;

  String? get publicationTypeError {
    if (!showErrors || publicationTypeValid) return null;
    return 'Campo obrigatório';
  }

  // Artigo
  @readonly
  late String _journalName = '';

  @action
  void setJournalName(String value) => _journalName = value;

  @readonly
  late String _volume = '';

  @action
  void setVolume(String value) => _volume = value;

  @readonly
  late String _issue = '';

  @action
  void setIssue(String value) => _issue = value;

  @readonly
  late String _pages = '';

  @action
  void setPages(String value) => _pages = value;

  @readonly
  late String _articlePublisher = '';

  @action
  void setArticlePublisher(String value) => _articlePublisher = value;

  @computed
  bool get journalNameValid =>
      _publicationType != PublicationType.article ||
      _journalName.trim().isNotEmpty;

  String? get journalNameError {
    if (!showErrors || journalNameValid) return null;
    return 'Campo obrigatório';
  }

  // Livro
  @readonly
  late String _bookPublisher = '';

  @action
  void setBookPublisher(String value) => _bookPublisher = value;

  @readonly
  late String _edition = '';

  @action
  void setEdition(String value) => _edition = value;

  // Capa do livro — imagem escolhida pelo usuário, enviada ao Cloudflare no
  // salvamento; a url_small retornada é usada como cover_photo.
  @readonly
  XFile? _coverPhotoFile;

  @action
  void setCoverPhotoFile(XFile? value) => _coverPhotoFile = value;

  // Capa já salva (preenchida na edição). Mantida quando nenhuma nova imagem
  // é escolhida.
  @readonly
  late String _existingCoverPhoto = '';

  @readonly
  late String _isbn = '';

  @action
  void setIsbn(String value) => _isbn = value;

  @readonly
  late String _bookUrl = '';

  @action
  void setBookUrl(String value) => _bookUrl = value;

  bool get _isBook => _publicationType == PublicationType.book;

  @computed
  bool get bookPublisherValid => !_isBook || _bookPublisher.trim().isNotEmpty;

  String? get bookPublisherError {
    if (!showErrors || bookPublisherValid) return null;
    return 'Campo obrigatório';
  }

  @computed
  bool get editionValid => !_isBook || _edition.trim().isNotEmpty;

  String? get editionError {
    if (!showErrors || editionValid) return null;
    return 'Campo obrigatório';
  }

  // ISBN-10 ou ISBN-13, com ou sem hífens/espaços.
  @computed
  bool get isbnValid {
    if (!_isBook) return true;
    final digits = _isbn.replaceAll(RegExp(r'[\s-]'), '');
    return RegExp(r'^(\d{9}[\dXx]|\d{13})$').hasMatch(digits);
  }

  String? get isbnError {
    if (!showErrors || isbnValid) return null;
    if (_isbn.trim().isEmpty) return 'Campo obrigatório';
    return 'Informe um ISBN válido (10 ou 13 dígitos)';
  }

  // Exige URL http/https válida para evitar que links maliciosos
  // (javascript:, data:, etc.) sejam publicados.
  bool _isValidHttpUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  @computed
  bool get bookUrlValid {
    if (!_isBook) return true;
    final value = _bookUrl.trim();
    if (value.isEmpty) return true;
    return _isValidHttpUrl(value);
  }

  String? get bookUrlError {
    if (!showErrors || bookUrlValid) return null;
    return 'Informe uma URL válida (http:// ou https://)';
  }

  // Capítulo de Livro
  @readonly
  late String _bookName = '';

  @action
  void setBookName(String value) => _bookName = value;

  @readonly
  late String _chapterNumber = '';

  @action
  void setChapterNumber(String value) => _chapterNumber = value;

  bool get _isBookChapter => _publicationType == PublicationType.bookChapter;

  @computed
  bool get bookNameValid => !_isBookChapter || _bookName.trim().isNotEmpty;

  String? get bookNameError {
    if (!showErrors || bookNameValid) return null;
    return 'Campo obrigatório';
  }

  @computed
  bool get chapterNumberValid {
    if (!_isBookChapter) return true;
    final number = num.tryParse(_chapterNumber.trim());
    return number != null && number > 0;
  }

  String? get chapterNumberError {
    if (!showErrors || chapterNumberValid) return null;
    if (_chapterNumber.trim().isEmpty) return 'Campo obrigatório';
    return 'Informe um número válido';
  }

  // Tese
  @readonly
  Organizations? _organization;

  @action
  void setOrganization(Organizations? value) => _organization = value;

  @readonly
  late String _numberOfPages = '';

  @action
  void setNumberOfPages(String value) => _numberOfPages = value;

  bool get _isThesis => _publicationType == PublicationType.thesis;

  @computed
  bool get organizationValid => !_isThesis || _organization?.id != null;

  String? get organizationError {
    if (!showErrors || organizationValid) return null;
    return 'Campo obrigatório';
  }

  @computed
  bool get numberOfPagesValid {
    if (!_isThesis) return true;
    final number = int.tryParse(_numberOfPages.trim());
    return number != null && number > 0;
  }

  String? get numberOfPagesError {
    if (!showErrors || numberOfPagesValid) return null;
    if (_numberOfPages.trim().isEmpty) return 'Campo obrigatório';
    return 'Informe um número válido';
  }

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
      titleValid &&
      abstractValid &&
      publicationDateValid &&
      doiValid &&
      publicationTypeValid &&
      journalNameValid &&
      bookPublisherValid &&
      editionValid &&
      isbnValid &&
      bookUrlValid &&
      bookNameValid &&
      chapterNumberValid &&
      organizationValid &&
      numberOfPagesValid;

  Publications _buildPublication() => Publications(
        id: publication.id,
        title: _title.trim(),
        abstract: _abstract.trim(),
        publication_date: _publicationDate,
        doi: _doi.trim(),
        research_areas: selectedResearchAreas.toList(),
      );

  @action
  Future<void> createPublication() async {
    setError(null);
    setLoading(true);

    try {
      final created = await _repository.createPublication(_buildPublication());

      final publicationId = created.id;
      if (publicationId == null) {
        throw 'Publicação criada, mas o servidor não retornou o ID. '
            'Os contribuidores e o tipo não foram vinculados.';
      }

      await _saveNewContributors(publicationId);
      await _createTypeRecord(publicationId);

      setSavedOrUpdatedOrDeleted(true);
    } catch (e) {
      setError(e is String ? e : 'Erro ao criar publicação.');
    }

    setLoading(false);
  }

  @action
  Future<void> editPublication() async {
    setError(null);
    setLoading(true);

    publication.title = _title.trim();
    publication.abstract = _abstract.trim();
    publication.publication_date = _publicationDate;
    publication.doi = _doi.trim();
    publication.research_areas = selectedResearchAreas.toList();

    try {
      await _repository.editPublication(publication);
      await _editTypeRecord();
      await _deleteRemovedContributors();
      await _saveNewContributors(publication.id!);
      setSavedOrUpdatedOrDeleted(true);
    } catch (e) {
      setError(e is String ? e : 'Erro ao editar publicação.');
    }

    setLoading(false);
  }

  @action
  Future<void> deletePublication() async {
    setError(null);
    setLoading(true);

    try {
      await _repository.deletePublication(publication.id!.toString());
      setSavedOrUpdatedOrDeleted(true);
    } catch (e) {
      setError(e is String ? e : 'Erro ao deletar publicação.');
    }

    setLoading(false);
  }

  /// Persiste os contribuidores ainda sem id. Autores externos novos são
  /// criados antes do contribuidor correspondente, na ordem da lista.
  Future<void> _saveNewContributors(int publicationId) async {
    for (var i = 0; i < contributors.length; i++) {
      final contributor = contributors[i];
      // Já persistidos (com id) ou carregados do servidor não são reenviados.
      if (contributor.id != null) continue;
      if (_originalContributors.contains(contributor)) continue;

      final externalAuthor = contributor.external_author;
      if (externalAuthor != null && externalAuthor.id == null) {
        final createdAuthor =
            await _externalAuthorsRepository.create(externalAuthor);
        contributor.external_author = createdAuthor;
      }

      contributor.publication = Publications(id: publicationId);
      contributor.order ??= i + 1;
      await _contributorsRepository.create(contributor);
    }
  }

  Future<void> _deleteRemovedContributors() async {
    final currentIds = contributors.map((c) => c.id).whereType<int>().toSet();
    for (final original in _originalContributors) {
      final id = original.id;
      if (id != null && !currentIds.contains(id)) {
        await _contributorsRepository.delete(id);
      }
    }
  }

  /// Resolve a capa do livro: envia a nova imagem ao Cloudflare e usa a
  /// url_small; se nenhuma foi escolhida, mantém a capa já existente.
  Future<String> _resolveCoverPhoto() async {
    final file = _coverPhotoFile;
    if (file == null) return _existingCoverPhoto;
    final upload = await _imageUploadRepository.uploadImage(
      file: file,
      entityType: 'member',
      entityId: _userStore.userId ?? 0,
    );
    return upload.urlSmall.isNotEmpty ? upload.urlSmall : upload.bestUrl;
  }

  Future<void> _createTypeRecord(int publicationId) async {
    final publicationRef = Publications(id: publicationId);

    switch (_publicationType!) {
      case PublicationType.article:
        await _articlesRepository.createArticles(Articles(
          publication: publicationRef,
          journal_name: _journalName.trim(),
          volume: _volume.trim(),
          issue: _issue.trim(),
          pages: _pages.trim(),
          publisher: _articlePublisher.trim(),
        ));
      case PublicationType.book:
        await _booksRepository.createBooks(Books(
          publication: publicationRef,
          publisher: _bookPublisher.trim(),
          edition: _edition.trim(),
          cover_photo: await _resolveCoverPhoto(),
          isbn: _isbn.trim(),
          book_url: _bookUrl.trim(),
        ));
      case PublicationType.bookChapter:
        await _bookChaptersRepository.createBookChapters(BookChapters(
          publication: publicationRef,
          book_name: _bookName.trim(),
          chapter_number: num.parse(_chapterNumber.trim()),
        ));
      case PublicationType.thesis:
        await _thesisRepository.createThesis(Thesis(
          publication: publicationRef,
          organization: _organization,
          number_of_pages: int.parse(_numberOfPages.trim()),
        ));
    }
  }

  /// Atualiza o registro de tipo da publicação em edição. O tipo em si não é
  /// alterado; apenas seus campos. Se o tipo não foi detectado, nada é feito.
  Future<void> _editTypeRecord() async {
    final type = _publicationType;
    if (type == null) return;
    final publicationRef = Publications(id: publication.id);

    switch (type) {
      case PublicationType.article:
        await _articlesRepository.editArticles(Articles(
          publication: publicationRef,
          journal_name: _journalName.trim(),
          volume: _volume.trim(),
          issue: _issue.trim(),
          pages: _pages.trim(),
          publisher: _articlePublisher.trim(),
        ));
      case PublicationType.book:
        await _booksRepository.editBooks(Books(
          publication: publicationRef,
          publisher: _bookPublisher.trim(),
          edition: _edition.trim(),
          cover_photo: await _resolveCoverPhoto(),
          isbn: _isbn.trim(),
          book_url: _bookUrl.trim(),
        ));
      case PublicationType.bookChapter:
        await _bookChaptersRepository.editBookChapters(BookChapters(
          publication: publicationRef,
          book_name: _bookName.trim(),
          chapter_number: num.parse(_chapterNumber.trim()),
        ));
      case PublicationType.thesis:
        await _thesisRepository.editThesis(Thesis(
          publication: publicationRef,
          organization: _organization,
          number_of_pages: int.parse(_numberOfPages.trim()),
        ));
    }
  }
}
