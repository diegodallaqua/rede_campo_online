import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/core/models/member_roles.dart';
import 'package:rede_campo_online/core/models/organizations.dart';
import 'package:rede_campo_online/core/ui/forms/custom_text_field.dart';
import 'package:rede_campo_online/core/ui/forms/entity_picker_field.dart';
import 'package:rede_campo_online/core/ui/forms/profile_image_field.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/bottom_action_bar.dart';
import 'package:rede_campo_online/core/ui/widgets/confirmation_dialog.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_mobile_page_scaffold.dart';
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
  late final AdminCreateMemberStore _createMemberStore;
  late final ReactionDisposer _whenDisposer;
  late final ReactionDisposer _errorDisposer;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _lattesUrlController;
  late final TextEditingController _linkedInUrlController;

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

    _whenDisposer = when(
      (_) => _createMemberStore.savedOrUpdatedOrDeleted,
      () {
        if (mounted) context.pop(true);
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
    super.dispose();
  }

  Future<void> _handleSave() async {
    _createMemberStore.invalidSendPressed();
    if (!_createMemberStore.isFormValid) return;
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
      await _createMemberStore.deleteMember();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminMobilePageScaffold(
        title: editing ? 'Editar Membro' : 'Novo Membro',
        subtitle: editing
            ? 'Edite os campos abaixo e salve as alterações.'
            : 'Preencha os campos abaixo para cadastrar um novo membro.',
        onBack: () => context.pop(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: Observer(
                  builder: (_) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        label: 'Nome',
                        controller: _nameController,
                        prefixIcon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (_) => _createMemberStore.nameError,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'E-mail',
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (_) => _createMemberStore.emailError,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: editing ? 'Nova senha (opcional)' : 'Senha',
                        controller: _passwordController,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _createMemberStore.obscurePassword,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (_) => _createMemberStore.passwordError,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _createMemberStore.obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color:
                                CustomColors.midnight_slate.withOpacity(0.45),
                            size: 20,
                          ),
                          onPressed:
                              _createMemberStore.togglePasswordVisibility,
                        ),
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      EntityPickerField<Organizations>(
                        label: 'Organização',
                        icon: Icons.apartment_outlined,
                        items:
                            _createMemberStore.availableOrganizations.toList(),
                        itemId: (org) => org.id,
                        itemLabel: (org) => org.name ?? '-',
                        selected: _createMemberStore.organization,
                        onChanged: _createMemberStore.setOrganization,
                        searchHint: 'Pesquisar organizações',
                        emptyLabel: 'Nenhuma organização selecionada',
                        emptyMessage: 'Nenhuma organização disponível.',
                        errorText: _createMemberStore.organizationError,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Descrição',
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: 6,
                        minLines: 3,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (_) => _createMemberStore.descriptionError,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Currículo Lattes (opcional)',
                        controller: _lattesUrlController,
                        prefixIcon: Icons.school_outlined,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (_) => _createMemberStore.lattesUrlError,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'LinkedIn (opcional)',
                        controller: _linkedInUrlController,
                        prefixIcon: Icons.link_rounded,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (_) => _createMemberStore.linkedInUrlError,
                      ),
                      const SizedBox(height: 16),
                      Observer(
                        builder: (_) => ProfileImageField(
                          existingImageUrl: _createMemberStore.profilePicture,
                          pickedFile: _createMemberStore.pendingProfileImage,
                          onPick: _createMemberStore.setProfileImage,
                          onRemove: _createMemberStore.removeProfileImage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Observer(
              builder: (_) => BottomActionBar(
                editing: editing,
                loading: _createMemberStore.loading,
                onSave: _handleSave,
                onDelete: editing ? _handleDelete : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
