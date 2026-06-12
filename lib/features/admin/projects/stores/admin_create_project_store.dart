import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/core/models/project_types.dart';
import 'package:rede_campo_online/core/models/research_areas.dart';
import 'package:rede_campo_online/core/repositories/image_upload_repository.dart';
import 'package:rede_campo_online/core/repositories/research_areas_repository.dart';
import 'package:rede_campo_online/core/models/pending_media.dart';
import 'package:rede_campo_online/features/members/models/members.dart';
import 'package:rede_campo_online/features/members/repositories/members_repository.dart';
import 'package:rede_campo_online/features/projects/models/project_media.dart';
import 'package:rede_campo_online/features/projects/models/projects.dart';
import 'package:rede_campo_online/features/projects/repositories/project_media_repository.dart';
import 'package:rede_campo_online/features/projects/repositories/project_types_repository.dart';
import 'package:rede_campo_online/features/projects/repositories/projects_repository.dart';

part 'admin_create_project_store.g.dart';

class AdminCreateProjectStore = AdminCreateProjectStoreBase
    with _$AdminCreateProjectStore;

abstract class AdminCreateProjectStoreBase with Store {
  AdminCreateProjectStoreBase(this.project) {
    _name = project.name ?? '';
    _description = project.description ?? '';
    _status = project.status ?? true;
    _beginDate = project.begin_date;
    _endDate = project.end_date;
    if (project.research_areas != null) {
      selectedResearchAreas.addAll(project.research_areas!);
    }
    if (project.members != null) {
      selectedMembers.addAll(project.members!);
    }
    loadProjectTypes();
    loadResearchAreas();
    loadMembers();
    if (project.id != null) loadExistingMedia();
  }

  final Projects project;
  final _repository = ProjectsRepository();
  final _projectTypesRepository = ProjectTypesRepository();
  final _researchAreasRepository = ResearchAreasRepository();
  final _membersRepository = MembersRepository();
  final _projectMediaRepository = ProjectMediaRepository();
  final _imageUploadRepository = ImageUploadRepository();

  // Tipos de projeto
  final availableProjectTypes = ObservableList<ProjectTypes>();

  @readonly
  ProjectTypes? _projectType;

  @action
  void setProjectType(ProjectTypes? value) => _projectType = value;

  Future<void> loadProjectTypes() async {
    try {
      final types = await _projectTypesRepository.findAll();
      runInAction(() {
        availableProjectTypes
          ..clear()
          ..addAll(types);
        // Reconcilia o tipo já vinculado ao projeto com a instância da lista
        // disponível, para que a seleção do dropdown funcione por igualdade.
        final currentId = project.projectType?.id ?? _projectType?.id;
        if (currentId != null) {
          for (final t in types) {
            if (t.id == currentId) {
              _projectType = t;
              break;
            }
          }
        }
      });
    } catch (_) {}
  }

  // Áreas de pesquisa
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

  // Membros
  final availableMembers = ObservableList<Members>();
  final selectedMembers = ObservableList<Members>();

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

  void setMembers(List<Members> members) {
    runInAction(() {
      selectedMembers
        ..clear()
        ..addAll(members);
    });
  }

  // Mídias (imagens)
  final pendingMedia = ObservableList<PendingMedia>();

  @action
  void addPendingMedia(XFile file) =>
      pendingMedia.add(PendingMedia(file: file));

  @action
  void removePendingMedia(int index) => pendingMedia.removeAt(index);

  @action
  void setPendingMediaName(int index, String name) =>
      pendingMedia[index].name = name;

  final existingMedia = ObservableList<ProjectMedia>();

  @action
  Future<void> loadExistingMedia() async {
    if (project.id == null) return;
    try {
      final media = await _projectMediaRepository.findByProjectId(project.id!);
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
      await _projectMediaRepository.deleteMedia(media.id!);
      existingMedia.removeAt(index);
    } catch (e) {
      setError(e is String ? e : 'Erro ao remover imagem.');
    }
  }

  Future<void> _uploadPendingMedia(int projectId) async {
    for (final item in pendingMedia) {
      final upload = await _imageUploadRepository.uploadImage(
        file: item.file,
        entityType: 'project',
        entityId: projectId,
      );
      await _projectMediaRepository.create(ProjectMedia(
        project: Projects(id: projectId),
        name: item.name.trim().isEmpty ? item.file.name : item.name.trim(),
        media: upload.bestUrl,
      ));
    }
  }

  // Dados do projeto
  @readonly
  late String _name = '';

  @action
  void setName(String value) => _name = value;

  @computed
  bool get nameValid => _name.trim().isNotEmpty && _name.length <= 200;

  String? get nameError {
    if (!showErrors || nameValid) return null;
    if (_name.trim().isEmpty) return 'Campo obrigatório';
    if (_name.length > 200) return 'Máximo de 200 caracteres';
    return null;
  }

  @readonly
  late String _description = '';

  @action
  void setDescription(String value) => _description = value;

  @computed
  bool get descriptionValid => _description.trim().isNotEmpty;

  String? get descriptionError {
    if (!showErrors || descriptionValid) return null;
    return 'Campo obrigatório';
  }

  @computed
  bool get projectTypeValid => _projectType?.id != null;

  String? get projectTypeError {
    if (!showErrors || projectTypeValid) return null;
    return 'Selecione um tipo de projeto';
  }

  @readonly
  bool _status = true;

  @action
  void setStatus(bool value) => _status = value;

  @readonly
  DateTime? _beginDate;

  @action
  void setBeginDate(DateTime? value) => _beginDate = value;

  @computed
  bool get beginDateValid => _beginDate != null;

  String? get beginDateError {
    if (!showErrors || beginDateValid) return null;
    return 'Campo obrigatório';
  }

  @readonly
  DateTime? _endDate;

  @action
  void setEndDate(DateTime? value) => _endDate = value;

  @computed
  bool get endDateValid => _endDate != null
      ? _beginDate != null && !_endDate!.isBefore(_beginDate!)
      : true;

  String? get endDateError {
    if (!showErrors || endDateValid) return null;
    if (_endDate == null) return 'Campo obrigatório';
    return 'A data de término não pode ser anterior ao início';
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
      nameValid &&
      descriptionValid &&
      projectTypeValid &&
      beginDateValid &&
      endDateValid;

  @action
  Future<void> createProject() async {
    setError(null);
    setLoading(true);

    try {
      final newProject = Projects(
        projectType: _projectType,
        name: _name.trim(),
        description: _description.trim(),
        status: _status,
        begin_date: _beginDate,
        end_date: _endDate,
        research_areas: selectedResearchAreas.toList(),
        members: selectedMembers.toList(),
      );
      final created = await _repository.createProject(newProject);

      if (pendingMedia.isNotEmpty) {
        final projectId = created.id;
        if (projectId == null) {
          throw 'Projeto criado, mas o servidor não retornou o ID. As imagens não foram vinculadas.';
        }
        await _uploadPendingMedia(projectId);
      }

      setSavedOrUpdatedOrDeleted(true);
    } catch (e) {
      setError(e is String ? e : 'Erro ao criar projeto.');
    }

    setLoading(false);
  }

  @action
  Future<void> editProject() async {
    setError(null);
    setLoading(true);

    project.projectType = _projectType;
    project.name = _name.trim();
    project.description = _description.trim();
    project.status = _status;
    project.begin_date = _beginDate;
    project.end_date = _endDate;
    project.research_areas = selectedResearchAreas.toList();
    project.members = selectedMembers.toList();

    try {
      await _repository.editProject(project);
      if (pendingMedia.isNotEmpty) {
        await _uploadPendingMedia(project.id!);
      }
      setSavedOrUpdatedOrDeleted(true);
    } catch (e) {
      setError(e is String ? e : 'Erro ao editar projeto.');
    }

    setLoading(false);
  }

  @action
  Future<void> deleteProject() async {
    setError(null);
    setLoading(true);

    try {
      await _repository.deleteProject(project.id!.toString());
      setSavedOrUpdatedOrDeleted(true);
    } catch (e) {
      setError(e is String ? e : 'Erro ao deletar projeto.');
    }

    setLoading(false);
  }
}
