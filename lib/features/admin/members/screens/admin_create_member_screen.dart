import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_leave_guard.dart';
import 'package:rede_campo_online/core/utils/admin_navigation.dart';
import 'package:rede_campo_online/features/admin/screens/widgets/admin_form_scaffold.dart';
import 'package:rede_campo_online/core/models/member_roles.dart';
import 'package:rede_campo_online/core/models/organizations.dart';
import 'package:rede_campo_online/core/ui/forms/custom_text_field.dart';
import 'package:rede_campo_online/core/ui/forms/entity_picker_field.dart';
import 'package:rede_campo_online/core/ui/forms/profile_image_field.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/confirmation_dialog.dart';
import 'package:rede_campo_online/features/admin/members/stores/admin_create_member_store.dart';
import 'package:rede_campo_online/features/members/models/members.dart';

class AdminCreateMemberScreen extends StatefulWidget {
  const AdminCreateMemberScreen({super.key, this.member});

  final Members? member;

  @override
  State<AdminCreateMemberScreen> createState() =>
      _AdminCreateMemberScreenState();
}

class _AdminCreateMemberScreenState extends State<AdminCreateMemberScreen> {
  late final bool editing;
  late final AdminLeaveGuard _leaveGuard;

  /// Mensagem do aviso de sucesso mostrado ao voltar para a lista.
  String? _resultMessage;
  late final AdminCreateMemberStore _createMemberStore;
  late final ReactionDisposer _whenDisposer;
  late final ReactionDisposer _errorDisposer;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _lattesUrlController;
  late final TextEditingController _linkedInUrlController;
  late final TextEditingController _instagramUrlController;

  @override
  void initState() {
    super.initState();
    editing = widget.member != null;
    _createMemberStore = AdminCreateMemberStore(widget.member ?? Members());

    _nameController = TextEditingController(text: widget.member?.name ?? '');
    _emailController = TextEditingController(text: widget.member?.email ?? '');
    _passwordController = TextEditingController();
    _descriptionController =
        TextEditingController(text: widget.member?.description ?? '');
    _lattesUrlController =
        TextEditingController(text: widget.member?.lattesUrl ?? '');
    _linkedInUrlController =
        TextEditingController(text: widget.member?.linkedInUrl ?? '');
    _instagramUrlController =
        TextEditingController(text: widget.member?.instagramUrl ?? '');

    _nameController
        .addListener(() => _createMemberStore.setName(_nameController.text));
    _emailController
        .addListener(() => _createMemberStore.setEmail(_emailController.text));
    _passwordController.addListener(
        () => _createMemberStore.setPassword(_passwordController.text));
    _descriptionController.addListener(
        () => _createMemberStore.setDescription(_descriptionController.text));
    _lattesUrlController.addListener(
        () => _createMemberStore.setLattesUrl(_lattesUrlController.text));
    _linkedInUrlController.addListener(
        () => _createMemberStore.setLinkedInUrl(_linkedInUrlController.text));
    _instagramUrlController.addListener(
        () => _createMemberStore.setInstagramUrl(_instagramUrlController.text));

    _leaveGuard = AdminLeaveGuard([
      _nameController,
      _emailController,
      _passwordController,
      _descriptionController,
      _lattesUrlController,
      _linkedInUrlController,
      _instagramUrlController
    ]);

    _whenDisposer = when(
      (_) => _createMemberStore.savedOrUpdatedOrDeleted,
      () {
        if (mounted) {
          closeAdminPage(context, AppRoutes.adminMembers, _resultMessage);
        }
      },
    );

    _errorDisposer = reaction(
      (_) => _createMemberStore.error,
      (error) {
        if (error != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: CustomColors.danger_red,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _whenDisposer();
    _errorDisposer();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _descriptionController.dispose();
    _lattesUrlController.dispose();
    _linkedInUrlController.dispose();
    _instagramUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    _createMemberStore.invalidSendPressed();
    if (!_createMemberStore.isFormValid) return;
    _resultMessage = editing ? 'Alterações salvas.' : 'Membro cadastrado.';
    if (editing) {
      await _createMemberStore.editMember();
    } else {
      await _createMemberStore.createMember();
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Apagar Membro',
      message:
          'Tem certeza que deseja apagar este membro? Esta ação não pode ser desfeita.',
      confirmLabel: 'Apagar',
    );

    if (confirmed == true) {
      _resultMessage = 'Membro apagado.';
      await _createMemberStore.deleteMember();
    }
  }

  void _handleBack() => _leaveGuard.leave(context, AppRoutes.adminMembers);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => AdminFormScaffold(
        sectionLabel: 'Membros',
        title: editing ? 'Editar Membro' : 'Novo Membro',
        subtitle: editing
            ? 'Edite os campos abaixo e salve as alterações.'
            : 'Preencha os campos abaixo para cadastrar um novo membro.',
        onBack: _handleBack,
        editing: editing,
        loading: _createMemberStore.loading,
        postLabel: 'Cadastrar',
        publishTitle: 'Cadastro',
        onSave: _handleSave,
        onDelete: editing ? _handleDelete : null,
        mainFields: [
          CustomTextField(
            label: 'Nome',
            controller: _nameController,
            prefixIcon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.always,
            validator: (_) => _createMemberStore.nameError,
          ),
          CustomTextField(
            label: 'E-mail',
            controller: _emailController,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.always,
            validator: (_) => _createMemberStore.emailError,
          ),
          CustomTextField(
            label: editing ? 'Nova senha (opcional)' : 'Senha',
            controller: _passwordController,
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: _createMemberStore.obscurePassword,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.always,
            validator: (_) => _createMemberStore.passwordError,
            suffixIcon: IconButton(
              tooltip: _createMemberStore.obscurePassword
                  ? 'Mostrar senha'
                  : 'Ocultar senha',
              icon: Icon(
                _createMemberStore.obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: CustomColors.midnight_slate.withOpacity(0.7),
                size: 20,
              ),
              onPressed: _createMemberStore.togglePasswordVisibility,
            ),
          ),
          CustomTextField(
            label: 'Descrição',
            controller: _descriptionController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: 8,
            minLines: 4,
            autovalidateMode: AutovalidateMode.always,
            validator: (_) => _createMemberStore.descriptionError,
          ),
          CustomTextField(
            label: 'Currículo Lattes (opcional)',
            controller: _lattesUrlController,
            prefixIcon: Icons.school_outlined,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.always,
            validator: (_) => _createMemberStore.lattesUrlError,
          ),
          CustomTextField(
            label: 'LinkedIn (opcional)',
            controller: _linkedInUrlController,
            prefixIcon: Icons.link_rounded,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.always,
            validator: (_) => _createMemberStore.linkedInUrlError,
          ),
          CustomTextField(
            label: 'Instagram (opcional)',
            controller: _instagramUrlController,
            prefixIcon: Icons.camera_alt_outlined,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            autovalidateMode: AutovalidateMode.always,
            validator: (_) => _createMemberStore.instagramUrlError,
          ),
        ],
        publishFields: [
          EntityPickerField<MemberRoles>(
            label: 'Papel',
            icon: Icons.badge_outlined,
            items: _createMemberStore.availableMemberRoles.toList(),
            itemId: (role) => role.id,
            itemLabel: (role) => role.name ?? '-',
            selected: _createMemberStore.memberRole,
            onChanged: _createMemberStore.setMemberRole,
            searchHint: 'Pesquisar papéis',
            emptyLabel: 'Nenhum papel selecionado',
            emptyMessage: 'Nenhum papel disponível.',
            errorText: _createMemberStore.memberRoleError,
          ),
          EntityPickerField<Organizations>(
            label: 'Organização',
            icon: Icons.apartment_outlined,
            items: _createMemberStore.availableOrganizations.toList(),
            itemId: (org) => org.id,
            itemLabel: (org) => org.name ?? '-',
            selected: _createMemberStore.organization,
            onChanged: _createMemberStore.setOrganization,
            searchHint: 'Pesquisar organizações',
            emptyLabel: 'Nenhuma organização selecionada',
            emptyMessage: 'Nenhuma organização disponível.',
            errorText: _createMemberStore.organizationError,
          ),
        ],
        sideFields: [
          ProfileImageField(
            existingImageUrl: _createMemberStore.profilePicture,
            pickedFile: _createMemberStore.pendingProfileImage,
            onPick: _createMemberStore.setProfileImage,
            onRemove: _createMemberStore.removeProfileImage,
          ),
        ],
      ),
    );
  }
}
