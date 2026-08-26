import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/core/ui/forms/custom_text_field.dart';
import 'package:rede_campo_online/core/ui/forms/entity_picker_field.dart';
import 'package:rede_campo_online/core/ui/forms/research_areas_field.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/admin/admin_mobile_page_scaffold.dart';
import 'package:rede_campo_online/core/ui/widgets/bottom_action_bar.dart';
import 'package:rede_campo_online/core/ui/widgets/confirmation_dialog.dart';
import 'package:rede_campo_online/core/ui/widgets/date_picker.dart';
import 'package:rede_campo_online/core/ui/widgets/small_loading_indicator.dart';
import 'package:rede_campo_online/features/admin/publications/screens/widgets/form/contributors_field.dart';
import 'package:rede_campo_online/features/admin/publications/screens/widgets/form/publication_form_controllers.dart';
import 'package:rede_campo_online/features/admin/publications/screens/widgets/form/publication_type_field.dart';
import 'package:rede_campo_online/features/admin/publications/screens/widgets/form/publication_type_form_fields.dart';
import 'package:rede_campo_online/features/admin/publications/stores/admin_create_publication_store.dart';
import 'package:rede_campo_online/features/projects/models/projects.dart';
import 'package:rede_campo_online/features/publications/models/publications.dart';

class AdminCreatePublicationScreen extends StatefulWidget {
  const AdminCreatePublicationScreen({super.key, this.publication});

  final Publications? publication;

  @override
  State<AdminCreatePublicationScreen> createState() =>
      _AdminCreatePublicationScreenState();
}

class _AdminCreatePublicationScreenState
    extends State<AdminCreatePublicationScreen> {
  late final bool editing;
  late final AdminCreatePublicationStore _store;
  late final PublicationFormControllers _controllers;
  late final ReactionDisposer _whenDisposer;
  late final ReactionDisposer _errorDisposer;
  late final ReactionDisposer _typeDisposer;

  @override
  void initState() {
    super.initState();
    editing = widget.publication != null;
    _store = AdminCreatePublicationStore(widget.publication ?? Publications());

    // Tipo detectado de forma síncrona (inline) já preenche os valores no
    // store; os controllers nascem a partir deles. Quando a detecção é
    // assíncrona (fallback), o _typeDisposer popula os controllers depois.
    _controllers = PublicationFormControllers(_store);

    _whenDisposer = when(
      (_) => _store.savedOrUpdatedOrDeleted,
      () {
        if (mounted) context.pop(true);
      },
    );

    _errorDisposer = reaction(
      (_) => _store.error,
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

    // Na edição, o tipo e seus campos chegam de forma assíncrona; quando o tipo
    // é detectado, preenche os controllers dos campos específicos.
    _typeDisposer = reaction(
      (_) => _store.publicationType,
      (type) {
        if (!editing || type == null) return;
        _controllers.syncTypeFields(_store);
      },
    );
  }

  @override
  void dispose() {
    _whenDisposer();
    _errorDisposer();
    _typeDisposer();
    _controllers.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    await openCalendar(
      context: context,
      initialDate: _store.publicationDate,
      onDateSelected: (date) => _store.setPublicationDate(date),
      firstDate: DateTime(1900),
    );
  }

  Future<void> _handleSave() async {
    _store.invalidSendPressed();
    if (!_store.isFormValid) return;
    if (editing) {
      await _store.editPublication();
    } else {
      await _store.createPublication();
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Apagar Publicação',
      message:
          'Tem certeza que deseja apagar esta publicação? Esta ação não pode ser desfeita.',
      confirmLabel: 'Apagar',
    );

    if (confirmed == true) {
      await _store.deletePublication();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminMobilePageScaffold(
        title: editing ? 'Editar Publicação' : 'Nova Publicação',
        subtitle: editing
            ? 'Edite os campos abaixo e salve as alterações.'
            : 'Preencha os campos abaixo para cadastrar uma nova publicação.',
        onBack: () => context.pop(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: Observer(builder: (_) => _buildForm()),
              ),
            ),
            Observer(
              builder: (_) => BottomActionBar(
                editing: editing,
                loading: _store.loading,
                onSave: _handleSave,
                onDelete: editing ? _handleDelete : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Título',
          controller: _controllers.title,
          prefixIcon: Icons.title_rounded,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.always,
          validator: (_) => _store.titleError,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Resumo',
          controller: _controllers.abstract_,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: 8,
          minLines: 5,
          autovalidateMode: AutovalidateMode.always,
          validator: (_) => _store.abstractError,
        ),
        const SizedBox(height: 16),
        DatePickerField(
          selectedDate: _store.publicationDate,
          onTap: _pickDate,
          errorText: _store.publicationDateError,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'DOI (opcional)',
          controller: _controllers.doi,
          prefixIcon: Icons.tag_rounded,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.always,
          validator: (_) => _store.doiError,
        ),
        const SizedBox(height: 16),
        Observer(
          builder: (_) => EntityPickerField<Projects>(
            label: 'Projeto (opcional)',
            icon: Icons.science_outlined,
            items: _store.availableProjects.toList(),
            itemId: (project) => project.id,
            itemLabel: (project) => project.name ?? '-',
            selected: _store.project,
            onChanged: _store.setProject,
            onClear: () => _store.setProject(null),
            searchHint: 'Pesquisar projetos',
            emptyLabel: 'Nenhum projeto vinculado',
            emptyMessage: 'Nenhum projeto disponível.',
          ),
        ),
        const SizedBox(height: 16),
        Observer(
          builder: (_) => ResearchAreasField(
            availableAreas: _store.availableResearchAreas.toList(),
            selectedAreas: _store.selectedResearchAreas.toList(),
            onChanged: _store.setResearchAreas,
          ),
        ),
        const SizedBox(height: 16),
        Observer(
          builder: (_) => ContributorsField(
            contributors: _store.contributors.toList(),
            availableMembers: _store.availableMembers.toList(),
            availableRoles: _store.availableContributorRoles.toList(),
            onAdd: _store.addContributor,
            onRemove: _store.removeContributor,
          ),
        ),
        const SizedBox(height: 24),
        ..._buildTypeSection(),
      ],
    );
  }

  List<Widget> _buildTypeSection() {
    final detectingType =
        editing && _store.loadingType && _store.publicationType == null;

    return [
      const Text(
        'Tipo de Publicação',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: CustomColors.midnight_slate,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        editing
            ? 'O tipo não pode ser alterado. Edite os campos abaixo.'
            : 'O tipo não poderá ser alterado após a publicação.',
        style: TextStyle(
          fontSize: 12,
          color: CustomColors.midnight_slate.withOpacity(0.5),
        ),
      ),
      const SizedBox(height: 12),
      if (detectingType)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Center(child: SmallLoadingIndicator(size: 22)),
        )
      else ...[
        PublicationTypeField(
          selectedType: _store.publicationType,
          onChanged: _store.setPublicationType,
          errorText: _store.publicationTypeError,
          // Trava o tipo detectado na edição; libera a seleção quando não foi
          // possível detectá-lo.
          enabled: !editing || _store.publicationType == null,
        ),
        PublicationTypeFormFields(store: _store, controllers: _controllers),
      ],
    ];
  }
}
