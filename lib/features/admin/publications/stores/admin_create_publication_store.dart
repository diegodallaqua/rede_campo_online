import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/core/models/academic_work_types.dart';
import 'package:rede_campo_online/core/models/contributor.dart';
import 'package:rede_campo_online/core/models/contributor_roles.dart';
import 'package:rede_campo_online/core/models/organizations.dart';
import 'package:rede_campo_online/core/models/research_areas.dart';
import 'package:rede_campo_online/core/repositories/academic_work_types_repository.dart';
import 'package:rede_campo_online/core/repositories/contributor_roles_repository.dart';
import 'package:rede_campo_online/core/repositories/contributors_repository.dart';
import 'package:rede_campo_online/core/repositories/external_authors_repository.dart';
import 'package:rede_campo_online/core/repositories/image_upload_repository.dart';
import 'package:rede_campo_online/core/repositories/organizations_repository.dart';
import 'package:rede_campo_online/core/repositories/research_areas_repository.dart';
import 'package:rede_campo_online/features/admin/publications/models/publication_type.dart';
import 'package:rede_campo_online/features/articles/models/articles.dart';
import 'package:rede_campo_online/features/articles/repositories/articles_repository.dart';
import 'package:rede_campo_online/features/book_chapters/models/book_chapters.dart';
import 'package:rede_campo_online/features/book_chapters/repositories/book_chapters_repository.dart';
import 'package:rede_campo_online/features/books/models/books.dart';
import 'package:rede_campo_online/features/books/repositories/books_repository.dart';
import 'package:rede_campo_online/features/members/models/members.dart';
import 'package:rede_campo_online/features/members/repositories/members_repository.dart';
import 'package:rede_campo_online/features/projects/models/projects.dart';
import 'package:rede_campo_online/features/projects/repositories/projects_repository.dart';
import 'package:rede_campo_online/features/publications/models/publications.dart';
import 'package:rede_campo_online/features/publications/repositories/publications_repository.dart';
import 'package:rede_campo_online/features/academic_works/models/academic_work.dart';
import 'package:rede_campo_online/features/academic_works/repositories/academic_work_repository.dart';
import '../../../../core/utils/validators.dart';

part 'admin_create_publication_store.g.dart';

class AdminCreatePublicationStore = AdminCreatePublicationStoreBase
    with _$AdminCreatePublicationStore;

abstract class AdminCreatePublicationStoreBase with Store {
  AdminCreatePublicationStoreBase(this.publication) {
    _title = publication.title ?? '';
    _abstract = publication.abstract ?? '';
    _doi = publication.doi ?? '';
    _publicationDate = publication.publication_date;
    _project = publication.project;
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
    loadAcademicWorkTypes();
    loadBooks();
    loadProjects();
    if (editing) {
      // Tipo vem em `details`; se ausente, detecta via endpoints de tipo.
      if (publication.publication_type != null) {
        _applyTypeFromPublication();
      } else {
        loadPublicationType();
      }
    }
  }

  final Publications publication;
  final _repository = PublicationsRepository();
  final _articlesRepository = const ArticlesRepository();
  final _booksRepository = const BooksRepository();
  final _bookChaptersRepository = const BookChaptersRepository();
  final _academicWorkRepository = const AcademicWorkRepository();
  final _contributorsRepository = ContributorsRepository();
  final _externalAuthorsRepository = ExternalAuthorsRepository();
  final _contributorRolesRepository = ContributorRolesRepository();
  final _organizationsRepository = OrganizationsRepository();
  final _academicWorkTypesRepository = AcademicWorkTypesRepository();
  final _researchAreasRepository = ResearchAreasRepository();
  final _membersRepository = MembersRepository();
  final _projectsRepository = ProjectsRepository();
  final _imageUploadRepository = ImageUploadRepository();
  final _organizationsList = ObservableList<Organizations>();

  bool get editing => publication.id != null;

  // Catálogos carregados da API
  final availableResearchAreas = ObservableList<ResearchAreas>();
  final selectedResearchAreas = ObservableList<ResearchAreas>();
  final availableMembers = ObservableList<Members>();
  final availableContributorRoles = ObservableList<ContributorRoles>();
  final availableProjects = ObservableList<Projects>();
  final availableAcademicWorkTypes = ObservableList<AcademicWorkType>();
  final availableBooks = ObservableList<Books>();

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

  Future<void> loadAcademicWorkTypes() async {
    try {
      final types = await _academicWorkTypesRepository.findAll();
      runInAction(() {
        availableAcademicWorkTypes
          ..clear()
          ..addAll(types);
      });
    } catch (_) {}
  }

  Future<void> loadBooks() async {
    try {
      final books = await _booksRepository.findAll(take: 100);
      runInAction(() {
        availableBooks
          ..clear()
          ..addAll(books);
      });
    } catch (_) {}
  }

  Future<void> loadProjects() async {
    try {
      final projects = await _projectsRepository.findAllProjects(take: 100);
      runInAction(() {
        availableProjects
          ..clear()
          ..addAll(projects);
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

  // Contribuidores (sem id: publication_id + author_order). Novos são
  // criados ao salvar.
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

  // Opcional; exige formato de DOI (10.xxxx/...).
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

  // Projeto vinculado (opcional, removível na edição).
  @readonly
  Projects? _project;

  @action
  void setProject(Projects? value) => _project = value;

  // Tipo: escolhido na criação, detectado e fixo na edição.
  @readonly
  PublicationType? _publicationType;

  @action
  void setPublicationType(PublicationType? value) => _publicationType = value;

  @readonly
  bool _loadingType = false;

  @action
  void _setLoadingType(bool value) => _loadingType = value;

  /// Detecta o tipo da publicação: tenta GET por id em cada endpoint de tipo
  /// e, se falhar, varre as listagens.
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

      final academicWork =
          await _academicWorkRepository.findByPublicationId(id);
      if (academicWork != null) {
        _applyAcademicWork(academicWork);
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
    final search = publication.title;
    try {
      final articles =
          await _articlesRepository.findAll(search: search, take: 100);
      for (final a in articles) {
        if (a.publication?.id == id) {
          _applyArticle(a);
          return true;
        }
      }

      final books = await _booksRepository.findAll(search: search, take: 100);
      for (final b in books) {
        if (b.publication?.id == id) {
          _applyBook(b);
          return true;
        }
      }

      final chapters =
          await _bookChaptersRepository.findAll(search: search, take: 100);
      for (final c in chapters) {
        if (c.publication?.id == id) {
          _applyBookChapter(c);
          return true;
        }
      }

      final academicWorks =
          await _academicWorkRepository.findAll(search: search, take: 100);
      for (final a in academicWorks) {
        if (a.publication?.id == id) {
          _applyAcademicWork(a);
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  /// Aplica o tipo e os atributos vindos inline em `details`.
  @action
  void _applyTypeFromPublication() {
    final type = PublicationType.fromApi(publication.publication_type);
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
        _book = d['book'] is Map
            ? Books.fromMap(Map<String, dynamic>.from(d['book']))
            : (d['book_id'] != null
                ? Books(
                    publication: Publications(
                      id: int.tryParse(d['book_id'].toString()),
                    ),
                  )
                : null);
        _chapterIsbn = (d['isbn'] ?? '').toString();
        _startPage = d['start_page']?.toString() ?? '';
        _endPage = d['end_page']?.toString() ?? '';
      case PublicationType.academicWork:
        _organization = d['organization'] is Map
            ? Organizations.fromMap(
                Map<String, dynamic>.from(d['organization']))
            : null;
        _numberOfPages = d['number_of_pages']?.toString() ?? '';
        _academicWorkType = d['academic_work_type'] is Map
            ? AcademicWorkType.fromMap(
                Map<String, dynamic>.from(d['academic_work_type']))
            : null;
        _defenseDate = d['defense_date'] != null
            ? DateTime.tryParse(d['defense_date'].toString())
            : null;
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
    _book = c.book;
    _chapterIsbn = c.isbn ?? '';
    _startPage = c.start_page?.toString() ?? '';
    _endPage = c.end_page?.toString() ?? '';
  }

  @action
  void _applyAcademicWork(AcademicWork a) {
    _publicationType = PublicationType.academicWork;
    _organization = a.organization;
    _numberOfPages = a.number_of_pages?.toString() ?? '';
    _academicWorkType = a.academic_work_type;
    _defenseDate = a.defense_date;
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

  // Capa do livro: enviada ao Cloudflare ao salvar; url_small vira cover_photo.
  @readonly
  XFile? _coverPhotoFile;

  @action
  void setCoverPhotoFile(XFile? value) => _coverPhotoFile = value;

  // Capa já salva, mantida se nenhuma nova for escolhida.
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
    return isIsbn(_isbn);
  }

  String? get isbnError {
    if (!showErrors || isbnValid) return null;
    if (_isbn.trim().isEmpty) return 'Campo obrigatório';
    return 'Informe um ISBN válido (10 ou 13 dígitos)';
  }

  @computed
  bool get bookUrlValid {
    if (!_isBook) return true;
    final value = _bookUrl.trim();
    if (value.isEmpty) return true;
    return isHttpUrl(value);
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
  bool get bookNameValid =>
      !_isBookChapter || hasLinkedBook || _bookName.trim().isNotEmpty;

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

  /// Livro ao qual o capítulo pertence. Vínculo opcional.
  @readonly
  Books? _book;

  @action
  void setBook(Books? value) => _book = value;

  @readonly
  late String _chapterIsbn = '';

  @action
  void setChapterIsbn(String value) => _chapterIsbn = value;

  @readonly
  late String _startPage = '';

  @action
  void setStartPage(String value) => _startPage = value;

  @readonly
  late String _endPage = '';

  @action
  void setEndPage(String value) => _endPage = value;

  /// Com livro vinculado, nome e ISBN vêm dele e não são pedidos.
  @computed
  bool get hasLinkedBook => _book != null;

  // ISBN opcional do capítulo, no mesmo formato do livro.
  @computed
  bool get chapterIsbnValid {
    if (!_isBookChapter || hasLinkedBook) return true;
    final value = _chapterIsbn.trim();
    if (value.isEmpty) return true;
    return isIsbn(value);
  }

  String? get chapterIsbnError {
    if (!showErrors || chapterIsbnValid) return null;
    return 'Informe um ISBN válido (10 ou 13 dígitos)';
  }

  @computed
  bool get startPageValid {
    if (!_isBookChapter || _startPage.trim().isEmpty) return true;
    final page = int.tryParse(_startPage.trim());
    return page != null && page > 0;
  }

  String? get startPageError {
    if (!showErrors || startPageValid) return null;
    return 'Informe um número válido';
  }

  @computed
  bool get endPageValid {
    if (!_isBookChapter || _endPage.trim().isEmpty) return true;
    final page = int.tryParse(_endPage.trim());
    if (page == null || page <= 0) return false;
    final start = int.tryParse(_startPage.trim());
    return start == null || page >= start;
  }

  String? get endPageError {
    if (!showErrors || endPageValid) return null;
    final page = int.tryParse(_endPage.trim());
    if (page == null || page <= 0) return 'Informe um número válido';
    return 'A página final não pode ser menor que a inicial';
  }

  // Trabalho Acadêmico
  @readonly
  Organizations? _organization;

  @action
  void setOrganization(Organizations? value) => _organization = value;

  @readonly
  late String _numberOfPages = '';

  @action
  void setNumberOfPages(String value) => _numberOfPages = value;

  @readonly
  AcademicWorkType? _academicWorkType;

  @action
  void setAcademicWorkType(AcademicWorkType? value) =>
      _academicWorkType = value;

  @readonly
  DateTime? _defenseDate;

  @action
  void setDefenseDate(DateTime? value) => _defenseDate = value;

  bool get _isAcademicWork => _publicationType == PublicationType.academicWork;

  @computed
  bool get organizationValid => !_isAcademicWork || _organization?.id != null;

  String? get organizationError {
    if (!showErrors || organizationValid) return null;
    return 'Campo obrigatório';
  }

  @computed
  bool get numberOfPagesValid {
    if (!_isAcademicWork) return true;
    final number = int.tryParse(_numberOfPages.trim());
    return number != null && number > 0;
  }

  String? get numberOfPagesError {
    if (!showErrors || numberOfPagesValid) return null;
    if (_numberOfPages.trim().isEmpty) return 'Campo obrigatório';
    return 'Informe um número válido';
  }

  @computed
  bool get academicWorkTypeValid =>
      !_isAcademicWork || _academicWorkType?.id != null;

  String? get academicWorkTypeError {
    if (!showErrors || academicWorkTypeValid) return null;
    return 'Campo obrigatório';
  }

  @computed
  bool get defenseDateValid => !_isAcademicWork || _defenseDate != null;

  String? get defenseDateError {
    if (!showErrors || defenseDateValid) return null;
    return 'Campo obrigatório';
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
      chapterIsbnValid &&
      startPageValid &&
      endPageValid &&
      organizationValid &&
      numberOfPagesValid &&
      academicWorkTypeValid &&
      defenseDateValid;

  Publications _buildPublication() => Publications(
        id: publication.id,
        title: _title.trim(),
        abstract: _abstract.trim(),
        publication_date: _publicationDate,
        doi: _doi.trim(),
        project: _project,
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
    publication.project = _project;
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

  /// Persiste contribuidores novos, criando antes os autores externos.
  Future<void> _saveNewContributors(int publicationId) async {
    for (var i = 0; i < contributors.length; i++) {
      final contributor = contributors[i];
      // Os carregados (_originalContributors) não são reenviados.
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

  // Removidos = originais fora da lista atual (por identidade, sem id).
  // Exclui antes de criar, liberando a ordem e evitando 409.
  Future<void> _deleteRemovedContributors() async {
    for (final original in _originalContributors) {
      final order = original.order;
      if (order != null && !contributors.contains(original)) {
        await _contributorsRepository.delete(publication.id!, order);
      }
    }
  }

  /// Envia a nova capa ao Cloudflare (url_small) ou mantém a existente.
  Future<String> _resolveCoverPhoto(int publicationId) async {
    final file = _coverPhotoFile;
    if (file == null) return _existingCoverPhoto;
    final upload = await _imageUploadRepository.uploadImage(
      file: file,
      entityType: 'book',
      entityId: publicationId,
    );
    return upload.urlSmall.isNotEmpty ? upload.urlSmall : upload.bestUrl;
  }

  /// Nome do livro do capítulo: o do livro vinculado ou o digitado.
  String get _resolvedBookName {
    final linkedTitle = _book?.publication?.title;
    if (linkedTitle != null && linkedTitle.isNotEmpty) return linkedTitle;
    return _bookName.trim();
  }

  /// ISBN do capítulo: null com livro vinculado ou campo em branco.
  String? get _resolvedChapterIsbn {
    if (hasLinkedBook) return null;
    final value = _chapterIsbn.trim();
    return value.isEmpty ? null : value;
  }

  Future<void> _createTypeRecord(int publicationId) async {
    final publicationRef = Publications(id: publicationId);

    switch (_publicationType!) {
      case PublicationType.article:
        await _articlesRepository.create(Articles(
          publication: publicationRef,
          journal_name: _journalName.trim(),
          volume: _volume.trim(),
          issue: _issue.trim(),
          pages: _pages.trim(),
          publisher: _articlePublisher.trim(),
        ));
      case PublicationType.book:
        await _booksRepository.create(Books(
          publication: publicationRef,
          publisher: _bookPublisher.trim(),
          edition: _edition.trim(),
          cover_photo: await _resolveCoverPhoto(publicationId),
          isbn: _isbn.trim(),
          book_url: _bookUrl.trim(),
        ));
      case PublicationType.bookChapter:
        await _bookChaptersRepository.create(BookChapters(
          publication: publicationRef,
          book_name: _resolvedBookName,
          chapter_number: num.parse(_chapterNumber.trim()),
          book: _book,
          isbn: _resolvedChapterIsbn,
          start_page: int.tryParse(_startPage.trim()),
          end_page: int.tryParse(_endPage.trim()),
        ));
      case PublicationType.academicWork:
        await _academicWorkRepository.create(AcademicWork(
          publication: publicationRef,
          organization: _organization,
          number_of_pages: int.parse(_numberOfPages.trim()),
          academic_work_type: _academicWorkType,
          defense_date: _defenseDate,
        ));
    }
  }

  /// Atualiza os campos do tipo (não o tipo). Sem tipo, nada faz.
  Future<void> _editTypeRecord() async {
    final type = _publicationType;
    if (type == null) return;
    final publicationRef = Publications(id: publication.id);

    switch (type) {
      case PublicationType.article:
        await _articlesRepository.edit(Articles(
          publication: publicationRef,
          journal_name: _journalName.trim(),
          volume: _volume.trim(),
          issue: _issue.trim(),
          pages: _pages.trim(),
          publisher: _articlePublisher.trim(),
        ));
      case PublicationType.book:
        await _booksRepository.edit(Books(
          publication: publicationRef,
          publisher: _bookPublisher.trim(),
          edition: _edition.trim(),
          cover_photo: await _resolveCoverPhoto(publication.id ?? 0),
          isbn: _isbn.trim(),
          book_url: _bookUrl.trim(),
        ));
      case PublicationType.bookChapter:
        await _bookChaptersRepository.edit(BookChapters(
          publication: publicationRef,
          book_name: _resolvedBookName,
          chapter_number: num.parse(_chapterNumber.trim()),
          book: _book,
          isbn: _resolvedChapterIsbn,
          start_page: int.tryParse(_startPage.trim()),
          end_page: int.tryParse(_endPage.trim()),
        ));
      case PublicationType.academicWork:
        await _academicWorkRepository.edit(AcademicWork(
          publication: publicationRef,
          organization: _organization,
          number_of_pages: int.parse(_numberOfPages.trim()),
          academic_work_type: _academicWorkType,
          defense_date: _defenseDate,
        ));
    }
  }
}
