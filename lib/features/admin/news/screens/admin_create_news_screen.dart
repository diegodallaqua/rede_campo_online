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
import 'package:rede_campo_online/core/ui/forms/media_upload_field.dart';
import 'package:rede_campo_online/core/ui/forms/research_areas_field.dart';
import 'package:rede_campo_online/features/admin/news/stores/admin_create_news_store.dart';
import 'package:rede_campo_online/features/news/models/news.dart';

class AdminCreateNewsScreen extends StatefulWidget {
  const AdminCreateNewsScreen({super.key, this.news});

  final News? news;

  @override
  State<AdminCreateNewsScreen> createState() => _AdminCreateNewsScreenState();
}

class _AdminCreateNewsScreenState extends State<AdminCreateNewsScreen> {
  late final bool editing;
  late final AdminLeaveGuard _leaveGuard;

  /// Mensagem do aviso de sucesso mostrado ao voltar para a lista.
  String? _resultMessage;
  late final AdminCreateNewsStore _createNewsStore;
  late final ReactionDisposer _whenDisposer;
  late final ReactionDisposer _errorDisposer;

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    editing = widget.news != null;
    _createNewsStore = AdminCreateNewsStore(widget.news ?? News());

    _titleController = TextEditingController(text: widget.news?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.news?.description ?? '');
    _contentController =
        TextEditingController(text: widget.news?.content ?? '');

    _titleController
        .addListener(() => _createNewsStore.setTitle(_titleController.text));
    _descriptionController.addListener(
        () => _createNewsStore.setDescription(_descriptionController.text));
    _contentController.addListener(
        () => _createNewsStore.setContent(_contentController.text));

    _leaveGuard = AdminLeaveGuard(
        [_titleController, _descriptionController, _contentController]);

    _whenDisposer = when(
      (_) => _createNewsStore.savedOrUpdatedOrDeleted,
      () {
        if (mounted) {
          closeAdminPage(context, AppRoutes.adminNews, _resultMessage);
        }
      },
    );

    _errorDisposer = reaction(
      (_) => _createNewsStore.error,
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
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    await openCalendar(
      context: context,
      initialDate: _createNewsStore.publicationDate,
      onDateSelected: (date) => _createNewsStore.setPublicationDate(date),
    );
  }

  Future<void> _handleSave() async {
    _createNewsStore.invalidSendPressed();
    if (!_createNewsStore.isFormValid) return;
    _resultMessage = editing ? 'Alterações salvas.' : 'Notícia publicada.';
    if (editing) {
      await _createNewsStore.editNews();
    } else {
      await _createNewsStore.createNews();
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Apagar Notícia',
      message:
          'Tem certeza que deseja apagar esta notícia? Esta ação não pode ser desfeita.',
      confirmLabel: 'Apagar',
    );

    if (confirmed == true) {
      _resultMessage = 'Notícia apagada.';
      await _createNewsStore.deleteNews();
    }
  }

  void _handleBack() => _leaveGuard.leave(context, AppRoutes.adminNews);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => AdminFormScaffold(
        sectionLabel: 'Notícias',
        title: editing ? 'Editar Notícia' : 'Nova Notícia',
        subtitle: editing
            ? 'Edite os campos abaixo e salve as alterações.'
            : 'Preencha os campos abaixo para publicar uma nova notícia.',
        onBack: _handleBack,
        editing: editing,
        loading: _createNewsStore.loading,
        onSave: _handleSave,
        onDelete: editing ? _handleDelete : null,
        mainFields: [
          CustomTextField(
            label: 'Manchete',
            controller: _titleController,
            prefixIcon: Icons.title_rounded,
            textInputAction: TextInputAction.next,
            validator: (_) => _createNewsStore.titleError,
          ),
          CustomTextField(
            label: 'Subtítulo',
            controller: _descriptionController,
            prefixIcon: Icons.short_text_rounded,
            textInputAction: TextInputAction.next,
            maxLines: 2,
            minLines: 2,
            validator: (_) => _createNewsStore.descriptionError,
          ),
          CustomTextField(
            label: 'Corpo da Notícia',
            controller: _contentController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: 14,
            minLines: 8,
            validator: (_) => _createNewsStore.contentError,
          ),
        ],
        publishFields: [
          DatePickerField(
            selectedDate: _createNewsStore.publicationDate,
            onTap: _pickDate,
            errorText: _createNewsStore.publicationDateError,
          ),
        ],
        sideFields: [
          ResearchAreasField(
            availableAreas: _createNewsStore.availableResearchAreas.toList(),
            selectedAreas: _createNewsStore.selectedResearchAreas.toList(),
            onChanged: _createNewsStore.setResearchAreas,
          ),
          MediaUploadField(
            existingItems: _createNewsStore.existingMedia.toList(),
            items: _createNewsStore.pendingMedia.toList(),
            onPickImage: _createNewsStore.addPendingMedia,
            onRemove: _createNewsStore.removePendingMedia,
            onNameChanged: _createNewsStore.setPendingMediaName,
            onDeleteExisting: _createNewsStore.deleteExistingMedia,
          ),
        ],
      ),
    );
  }
}
