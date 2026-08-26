import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/core/models/addresses.dart';
import 'package:rede_campo_online/core/repositories/addresses_repository.dart';
import 'package:rede_campo_online/core/repositories/image_upload_repository.dart';
import 'package:rede_campo_online/core/models/pending_media.dart';
import 'package:rede_campo_online/features/events/models/events.dart';
import 'package:rede_campo_online/features/events/models/events_media.dart';
import 'package:rede_campo_online/features/events/repositories/event_media_repository.dart';
import 'package:rede_campo_online/features/events/repositories/events_repository.dart';
import 'package:rede_campo_online/features/projects/models/projects.dart';
import 'package:rede_campo_online/features/projects/repositories/projects_repository.dart';

part 'admin_create_event_store.g.dart';

class AdminCreateEventStore = AdminCreateEventStoreBase
    with _$AdminCreateEventStore;

abstract class AdminCreateEventStoreBase with Store {
  AdminCreateEventStoreBase(this.event) {
    _name = event.name ?? '';
    _description = event.description ?? '';
    _registrationUrl = event.registration_url ?? '';
    _date = event.date;
    _project = event.project;
    _address = event.address;
    loadProjects();
    loadAddresses();
    if (event.id != null) loadExistingMedia();
  }

  final Events event;
  final _repository = EventsRepository();
  final _eventMediaRepository = EventMediaRepository();
  final _imageUploadRepository = ImageUploadRepository();
  final _projectsRepository = ProjectsRepository();
  final _addressesRepository = AddressesRepository();

  final availableProjects = ObservableList<Projects>();
  final availableAddresses = ObservableList<Addresses>();

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

  Future<void> loadAddresses() async {
    try {
      final addresses = await _addressesRepository.findAll();
      runInAction(() {
        availableAddresses
          ..clear()
          ..addAll(addresses);
      });
    } catch (_) {}
  }

  final pendingMedia = ObservableList<PendingMedia>();

  @action
  void addPendingMedia(XFile file) =>
      pendingMedia.add(PendingMedia(file: file));

  @action
  void removePendingMedia(int index) => pendingMedia.removeAt(index);

  @action
  void setPendingMediaName(int index, String name) =>
      pendingMedia[index].name = name;

  final existingMedia = ObservableList<EventMedia>();

  @action
  Future<void> loadExistingMedia() async {
    if (event.id == null) return;
    try {
      final media = await _eventMediaRepository.findByEventId(event.id!);
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
      await _eventMediaRepository.deleteMedia(media.id!);
      existingMedia.removeAt(index);
    } catch (e) {
      setError(e is String ? e : 'Erro ao remover imagem.');
    }
  }

  @readonly
  Projects? _project;

  @action
  void setProject(Projects? value) => _project = value;

  @computed
  bool get projectValid => _project?.id != null;

  String? get projectError {
    if (!showErrors || projectValid) return null;
    return 'Campo obrigatório';
  }

  @readonly
  Addresses? _address;

  @action
  void setAddress(Addresses? value) => _address = value;

  @computed
  bool get addressValid => _address?.id != null;

  String? get addressError {
    if (!showErrors || addressValid) return null;
    return 'Campo obrigatório';
  }

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

  @readonly
  DateTime? _date;

  @action
  void setDate(DateTime? value) => _date = value;

  @computed
  bool get dateValid => _date != null;

  String? get dateError {
    if (!showErrors || dateValid) return null;
    return 'Campo obrigatório';
  }

  @readonly
  late String _registrationUrl = '';

  @action
  void setRegistrationUrl(String value) => _registrationUrl = value;

  // Opcional; quando preenchido exige URL http/https válida para evitar
  // que links maliciosos (javascript:, data:, etc.) sejam publicados.
  @computed
  bool get registrationUrlValid {
    final value = _registrationUrl.trim();
    if (value.isEmpty) return true;
    if (value.length > 500) return false;
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  String? get registrationUrlError {
    if (!showErrors || registrationUrlValid) return null;
    if (_registrationUrl.length > 500) return 'Máximo de 500 caracteres';
    return 'Informe uma URL válida (http:// ou https://)';
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
      projectValid &&
      addressValid &&
      nameValid &&
      descriptionValid &&
      dateValid &&
      registrationUrlValid;

  @action
  Future<void> createEvent() async {
    setError(null);
    setLoading(true);

    try {
      final newEvent = Events(
        project: _project,
        address: _address,
        name: _name.trim(),
        description: _description.trim(),
        registration_url: _registrationUrl.trim(),
        date: _date,
      );
      final created = await _repository.createEvent(newEvent);

      if (pendingMedia.isNotEmpty) {
        final eventId = created.id;
        if (eventId == null) {
          throw 'Evento criado, mas o servidor não retornou o ID. As imagens não foram vinculadas.';
        }
        await _uploadPendingMedia(eventId);
      }

      setSavedOrUpdatedOrDeleted(true);
    } catch (e) {
      setError(e is String ? e : 'Erro ao criar evento.');
    }

    setLoading(false);
  }

  Future<void> _uploadPendingMedia(int eventId) async {
    for (final item in pendingMedia) {
      final upload = await _imageUploadRepository.uploadImage(
        file: item.file,
        entityType: 'event',
        entityId: eventId,
      );
      await _eventMediaRepository.create(EventMedia(
        event: Events(id: eventId),
        name: item.name.trim().isEmpty ? item.file.name : item.name.trim(),
        media: upload.bestUrl,
      ));
    }
  }

  @action
  Future<void> editEvent() async {
    setError(null);
    setLoading(true);

    event.project = _project;
    event.address = _address;
    event.name = _name.trim();
    event.description = _description.trim();
    event.registration_url = _registrationUrl.trim();
    event.date = _date;

    try {
      await _repository.editEvent(event);
      if (pendingMedia.isNotEmpty) {
        await _uploadPendingMedia(event.id!);
      }
      setSavedOrUpdatedOrDeleted(true);
    } catch (e) {
      setError(e is String ? e : 'Erro ao editar evento.');
    }

    setLoading(false);
  }

  @action
  Future<void> deleteEvent() async {
    setError(null);
    setLoading(true);

    try {
      await _repository.deleteEvent(event.id!.toString());
      setSavedOrUpdatedOrDeleted(true);
    } catch (e) {
      setError(e is String ? e : 'Erro ao deletar evento.');
    }

    setLoading(false);
  }
}
