import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/core/ui/forms/custom_text_field.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/bottom_action_bar.dart';
import 'package:rede_campo_online/core/ui/widgets/confirmation_dialog.dart';
import 'package:rede_campo_online/core/ui/widgets/date_picker.dart';
import 'package:rede_campo_online/core/ui/widgets/gradient_header.dart';
import 'package:rede_campo_online/features/admin/news/screens/widgets/research_areas_field.dart';
import 'package:rede_campo_online/features/admin/projects/screens/widgets/members_field.dart';
import 'package:rede_campo_online/features/admin/projects/screens/widgets/project_media_upload_field.dart';
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

    _whenDisposer = when(
      (_) => _createProjectStore.savedOrUpdatedOrDeleted,
      () {
        if (mounted) context.pop(true);
      },
    );

    _errorDisposer = reaction(
      (_) => _createProjectStore.error,
      (error) {
        if (error != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: const Color(0xFFCF1322),
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
      await _createProjectStore.deleteProject();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [CustomColors.copper_spice, CustomColors.midnight_slate],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              GradientHeader(
                title: editing ? 'Editar Projeto' : 'Novo Projeto',
                subtitle: editing
                    ? 'Edite os campos abaixo e salve as alterações.'
                    : 'Preencha os campos abaixo para cadastrar um novo projeto.',
                onBack: () => context.pop(),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: CustomColors.salt_flower,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  clipBehavior: Clip.antiAlias,
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
                                  label: 'Nome do Projeto',
                                  controller: _nameController,
                                  prefixIcon: Icons.work_outline_rounded,
                                  textInputAction: TextInputAction.next,
                                  validator: (_) =>
                                      _createProjectStore.nameError,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  label: 'Descrição',
                                  controller: _descriptionController,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  maxLines: 8,
                                  minLines: 5,
                                  validator: (_) =>
                                      _createProjectStore.descriptionError,
                                ),
                                const SizedBox(height: 16),
                                ProjectTypeField(
                                  availableTypes: _createProjectStore
                                      .availableProjectTypes
                                      .toList(),
                                  selectedType: _createProjectStore.projectType,
                                  onChanged: _createProjectStore.setProjectType,
                                  errorText:
                                      _createProjectStore.projectTypeError,
                                ),
                                const SizedBox(height: 16),
                                ProjectStatusField(
                                  active: _createProjectStore.status,
                                  onChanged: _createProjectStore.setStatus,
                                ),
                                const SizedBox(height: 16),
                                DatePickerField(
                                  placeholder: 'Data de início',
                                  selectedDate: _createProjectStore.beginDate,
                                  onTap: _pickBeginDate,
                                  errorText: _createProjectStore.beginDateError,
                                ),
                                const SizedBox(height: 16),
                                DatePickerField(
                                  placeholder: 'Data de término',
                                  selectedDate: _createProjectStore.endDate,
                                  onTap: _pickEndDate,
                                  errorText: _createProjectStore.endDateError,
                                ),
                                const SizedBox(height: 16),
                                MembersField(
                                  availableMembers: _createProjectStore
                                      .availableMembers
                                      .toList(),
                                  selectedMembers: _createProjectStore
                                      .selectedMembers
                                      .toList(),
                                  onChanged: _createProjectStore.setMembers,
                                ),
                                const SizedBox(height: 16),
                                ResearchAreasField(
                                  availableAreas: _createProjectStore
                                      .availableResearchAreas
                                      .toList(),
                                  selectedAreas: _createProjectStore
                                      .selectedResearchAreas
                                      .toList(),
                                  onChanged:
                                      _createProjectStore.setResearchAreas,
                                ),
                                const SizedBox(height: 16),
                                ProjectMediaUploadField(
                                  existingItems: _createProjectStore
                                      .existingMedia
                                      .toList(),
                                  items:
                                      _createProjectStore.pendingMedia.toList(),
                                  onPickImage:
                                      _createProjectStore.addPendingMedia,
                                  onRemove:
                                      _createProjectStore.removePendingMedia,
                                  onNameChanged:
                                      _createProjectStore.setPendingMediaName,
                                  onDeleteExisting:
                                      _createProjectStore.deleteExistingMedia,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Observer(
                        builder: (_) => BottomActionBar(
                          editing: editing,
                          loading: _createProjectStore.loading,
                          postLabel: 'Cadastrar',
                          onSave: _handleSave,
                          onDelete: editing ? _handleDelete : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
