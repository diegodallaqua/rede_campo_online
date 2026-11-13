import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_leave_guard.dart';
import 'package:rede_campo_online/core/utils/admin_navigation.dart';
import 'package:rede_campo_online/features/admin/screens/widgets/admin_form_scaffold.dart';
import 'package:rede_campo_online/core/ui/forms/custom_text_field.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/confirmation_dialog.dart';
import 'package:rede_campo_online/core/ui/widgets/date_picker.dart';
import 'package:rede_campo_online/core/ui/forms/research_areas_field.dart';
import 'package:rede_campo_online/features/admin/projects/screens/widgets/members_field.dart';
import 'package:rede_campo_online/core/ui/forms/media_upload_field.dart';
import 'package:rede_campo_online/features/admin/projects/screens/widgets/project_type_field.dart';
import 'package:rede_campo_online/features/admin/projects/stores/admin_create_project_store.dart';
import 'package:rede_campo_online/features/projects/models/projects.dart';

class AdminCreateProjectScreen extends StatefulWidget {
  const AdminCreateProjectScreen({super.key, this.project});

  final Projects? project;

  @override
  State<AdminCreateProjectScreen> createState() =>
      _AdminCreateProjectScreenState();
}

class _AdminCreateProjectScreenState extends State<AdminCreateProjectScreen> {
  late final bool editing;
  late final AdminLeaveGuard _leaveGuard;

  /// Mensagem do aviso de sucesso mostrado ao voltar para a lista.
  String? _resultMessage;
  late final AdminCreateProjectStore _createProjectStore;
  late final ReactionDisposer _whenDisposer;
  late final ReactionDisposer _errorDisposer;

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    editing = widget.project != null;
    _createProjectStore = AdminCreateProjectStore(widget.project ?? Projects());

    _nameController = TextEditingController(text: widget.project?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.project?.description ?? '');

    _nameController
        .addListener(() => _createProjectStore.setName(_nameController.text));
    _descriptionController.addListener(
        () => _createProjectStore.setDescription(_descriptionController.text));

    _leaveGuard = AdminLeaveGuard([_nameController, _descriptionController]);

    _whenDisposer = when(
      (_) => _createProjectStore.savedOrUpdatedOrDeleted,
      () {
        if (mounted) {
          closeAdminPage(context, AppRoutes.adminProjects, _resultMessage);
        }
      },
    );

    _errorDisposer = reaction(
      (_) => _createProjectStore.error,
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
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickBeginDate() async {
    await openCalendar(
      context: context,
      initialDate: _createProjectStore.beginDate,
      onDateSelected: (date) => _createProjectStore.setBeginDate(date),
    );
  }

  Future<void> _pickEndDate() async {
    await openCalendar(
      context: context,
      initialDate: _createProjectStore.endDate ?? _createProjectStore.beginDate,
      onDateSelected: (date) => _createProjectStore.setEndDate(date),
    );
  }

  Future<void> _handleSave() async {
    _createProjectStore.invalidSendPressed();
    if (!_createProjectStore.isFormValid) return;
    _resultMessage = editing ? 'Alterações salvas.' : 'Projeto cadastrado.';
    if (editing) {
      await _createProjectStore.editProject();
    } else {
      await _createProjectStore.createProject();
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Apagar Projeto',
      message:
          'Tem certeza que deseja apagar este projeto? Esta ação não pode ser desfeita.',
      confirmLabel: 'Apagar',
    );

    if (confirmed == true) {
      _resultMessage = 'Projeto apagado.';
      await _createProjectStore.deleteProject();
    }
  }

  void _handleBack() => _leaveGuard.leave(context, AppRoutes.adminProjects);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => AdminFormScaffold(
        sectionLabel: 'Projetos',
        title: editing ? 'Editar Projeto' : 'Novo Projeto',
        subtitle: editing
            ? 'Edite os campos abaixo e salve as alterações.'
            : 'Preencha os campos abaixo para cadastrar um novo projeto.',
        onBack: _handleBack,
        editing: editing,
        loading: _createProjectStore.loading,
        postLabel: 'Cadastrar',
        onSave: _handleSave,
        onDelete: editing ? _handleDelete : null,
        mainFields: [
          CustomTextField(
            label: 'Nome do Projeto',
            controller: _nameController,
            prefixIcon: Icons.work_outline_rounded,
            textInputAction: TextInputAction.next,
            autovalidateMode: AutovalidateMode.always,
            validator: (_) => _createProjectStore.nameError,
          ),
          CustomTextField(
            label: 'Descrição',
            controller: _descriptionController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: 12,
            minLines: 6,
            autovalidateMode: AutovalidateMode.always,
            validator: (_) => _createProjectStore.descriptionError,
          ),
          ProjectTypeField(
            availableTypes: _createProjectStore.availableProjectTypes.toList(),
            selectedType: _createProjectStore.projectType,
            onChanged: _createProjectStore.setProjectType,
            errorText: _createProjectStore.projectTypeError,
          ),
          MembersField(
            availableMembers: _createProjectStore.availableMembers.toList(),
            selectedMembers: _createProjectStore.selectedMembers.toList(),
            onChanged: _createProjectStore.setMembers,
          ),
        ],
        publishFields: [
          ProjectStatusField(
            active: _createProjectStore.status,
            onChanged: _createProjectStore.setStatus,
          ),
          DatePickerField(
            placeholder: 'Data de início',
            selectedDate: _createProjectStore.beginDate,
            onTap: _pickBeginDate,
            errorText: _createProjectStore.beginDateError,
          ),
          DatePickerField(
            placeholder: 'Data de término',
            selectedDate: _createProjectStore.endDate,
            onTap: _pickEndDate,
            errorText: _createProjectStore.endDateError,
          ),
        ],
        sideFields: [
          ResearchAreasField(
            availableAreas: _createProjectStore.availableResearchAreas.toList(),
            selectedAreas: _createProjectStore.selectedResearchAreas.toList(),
            onChanged: _createProjectStore.setResearchAreas,
          ),
          MediaUploadField(
            existingItems: _createProjectStore.existingMedia.toList(),
            items: _createProjectStore.pendingMedia.toList(),
            onPickImage: _createProjectStore.addPendingMedia,
            onRemove: _createProjectStore.removePendingMedia,
            onNameChanged: _createProjectStore.setPendingMediaName,
            onDeleteExisting: _createProjectStore.deleteExistingMedia,
          ),
        ],
      ),
    );
  }
}
