import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/core/global/injection.dart';
import 'package:rede_campo_online/core/models/member_roles.dart';
import 'package:rede_campo_online/core/models/organizations.dart';
import 'package:rede_campo_online/core/repositories/image_upload_repository.dart';
import 'package:rede_campo_online/core/repositories/member_roles_repository.dart';
import 'package:rede_campo_online/core/repositories/organizations_repository.dart';
import 'package:rede_campo_online/core/stores/user_manager_store.dart';
import 'package:rede_campo_online/features/members/models/members.dart';
import 'package:rede_campo_online/features/members/repositories/members_repository.dart';

part 'admin_create_member_store.g.dart';

class AdminCreateMemberStore = AdminCreateMemberStoreBase
    with _$AdminCreateMemberStore;

abstract class AdminCreateMemberStoreBase with Store {
  AdminCreateMemberStoreBase(this.member) {
    _name = member.name ?? '';
    _email = member.email ?? '';
    _description = member.description ?? '';
    _lattesUrl = member.lattesUrl ?? '';
    _linkedInUrl = member.linkedInUrl ?? '';
    _memberRole = member.memberRole;
    _organization = member.organization;
    _profilePicture = member.profilePicture ?? '';
    loadMemberRoles();
    loadOrganizations();
  }

  final Members member;
  final _repository = MembersRepository();
  final _memberRolesRepository = MemberRolesRepository();
  final _organizationsRepository = OrganizationsRepository();
  final _imageUploadRepository = ImageUploadRepository();
  final _userStore = getIt<UserManagerStore>();

  bool get editing => member.id != null;

  final availableMemberRoles = ObservableList<MemberRoles>();
  final availableOrganizations = ObservableList<Organizations>();

  Future<void> loadMemberRoles() async {
    try {
      final roles = await _memberRolesRepository.findAll();
      runInAction(() {
        availableMemberRoles
          ..clear()
          ..addAll(roles);
      });
    } catch (_) {}
  }

  Future<void> loadOrganizations() async {
    try {
      final organizations = await _organizationsRepository.findAll();
      runInAction(() {
        availableOrganizations
          ..clear()
          ..addAll(organizations);
      });
    } catch (_) {}
  }

  // Foto de perfil — imagem já persistida e/ou recém-selecionada.
  @readonly
  String _profilePicture = '';

  @readonly
  XFile? _pendingProfileImage;

  @action
  void setProfileImage(XFile file) => _pendingProfileImage = file;

  @action
  void removeProfileImage() {
    _pendingProfileImage = null;
    _profilePicture = '';
  }

  @readonly
  MemberRoles? _memberRole;

  @action
  void setMemberRole(MemberRoles? value) => _memberRole = value;

  @computed
  bool get memberRoleValid => _memberRole?.id != null;

  String? get memberRoleError {
    if (!showErrors || memberRoleValid) return null;
    return 'Campo obrigatório';
  }

  @readonly
  Organizations? _organization;

  @action
  void setOrganization(Organizations? value) => _organization = value;

  @computed
  bool get organizationValid => _organization?.id != null;

  String? get organizationError {
    if (!showErrors || organizationValid) return null;
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
  late String _email = '';

  @action
  void setEmail(String value) => _email = value;

  @observable
  bool obscurePassword = true;

  @action
  void togglePasswordVisibility() => obscurePassword = !obscurePassword;

  @readonly
  String _password = '';

  @action
  void setPassword(String value) => _password = value;

  // Obrigatória na criação; opcional na edição (em branco mantém a atual).
  @computed
  bool get passwordValid {
    if (editing && _password.isEmpty) return true;
    return _password.length >= 6 && _password.length <= 100;
  }

  String? get passwordError {
    if (!showErrors || passwordValid) return null;
    if (_password.isEmpty) return 'Campo obrigatório';
    if (_password.length < 6) return 'Mínimo de 6 caracteres';
    return 'Máximo de 100 caracteres';
  }

  @computed
  bool get emailValid {
    final value = _email.trim();
    if (value.isEmpty || value.length > 200) return false;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }

  String? get emailError {
    if (!showErrors || emailValid) return null;
    if (_email.trim().isEmpty) return 'Campo obrigatório';
    if (_email.length > 200) return 'Máximo de 200 caracteres';
    return 'Informe um e-mail válido';
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
  late String _lattesUrl = '';

  @action
  void setLattesUrl(String value) => _lattesUrl = value;

  @computed
  bool get lattesUrlValid => _isOptionalUrlValid(_lattesUrl);

  String? get lattesUrlError {
    if (!showErrors || lattesUrlValid) return null;
    if (_lattesUrl.length > 500) return 'Máximo de 500 caracteres';
    return 'Informe uma URL válida (http:// ou https://)';
  }

  @readonly
  late String _linkedInUrl = '';

  @action
  void setLinkedInUrl(String value) => _linkedInUrl = value;

  @computed
  bool get linkedInUrlValid => _isOptionalUrlValid(_linkedInUrl);

  String? get linkedInUrlError {
    if (!showErrors || linkedInUrlValid) return null;
    if (_linkedInUrl.length > 500) return 'Máximo de 500 caracteres';
    return 'Informe uma URL válida (http:// ou https://)';
  }

  // URL opcional; quando preenchida exige http/https válido para evitar que
  // links maliciosos (javascript:, data:, etc.) sejam publicados.
  bool _isOptionalUrlValid(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return true;
    if (value.length > 500) return false;
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
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
      emailValid &&
      passwordValid &&
      memberRoleValid &&
      organizationValid &&
      descriptionValid &&
      lattesUrlValid &&
      linkedInUrlValid;

  // Faz upload da imagem pendente (se houver) e devolve a URL a persistir.
  Future<String?> _resolveProfilePicture() async {
    if (_pendingProfileImage == null) {
      return _profilePicture.isEmpty ? null : _profilePicture;
    }
    final upload = await _imageUploadRepository.uploadImage(
      file: _pendingProfileImage!,
      entityType: 'member',
      entityId: _userStore.userId ?? 0,
    );
    return upload.bestUrl;
  }

  @action
  Future<void> createMember() async {
    setError(null);
    setLoading(true);

    try {
      final profilePicture = await _resolveProfilePicture();
      final newMember = Members(
        memberRole: _memberRole,
        organization: _organization,
        name: _name.trim(),
        email: _email.trim(),
        description: _description.trim(),
        lattesUrl: _lattesUrl.trim(),
        linkedInUrl: _linkedInUrl.trim(),
        profilePicture: profilePicture,
        password: _password,
      );
      await _repository.createMember(newMember);
      setSavedOrUpdatedOrDeleted(true);
    } catch (e) {
      setError(e is String ? e : 'Erro ao criar membro.');
    }

    setLoading(false);
  }

  @action
  Future<void> editMember() async {
    setError(null);
    setLoading(true);

    try {
      final profilePicture = await _resolveProfilePicture();
      member.memberRole = _memberRole;
      member.organization = _organization;
      member.name = _name.trim();
      member.email = _email.trim();
      member.description = _description.trim();
      member.lattesUrl = _lattesUrl.trim();
      member.linkedInUrl = _linkedInUrl.trim();
      member.profilePicture = profilePicture;
      // Em branco => não enviada; toMap preserva a senha atual no servidor.
      member.password = _password.isEmpty ? null : _password;

      await _repository.editMember(member);
      setSavedOrUpdatedOrDeleted(true);
    } catch (e) {
      setError(e is String ? e : 'Erro ao editar membro.');
    }

    setLoading(false);
  }

  @action
  Future<void> deleteMember() async {
    setError(null);
    setLoading(true);

    try {
      await _repository.deleteMember(member.id!.toString());
      setSavedOrUpdatedOrDeleted(true);
    } catch (e) {
      setError(e is String ? e : 'Erro ao deletar membro.');
    }

    setLoading(false);
  }
}
