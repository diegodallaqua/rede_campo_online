import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:rede_campo_online/core/ui/forms/custom_text_field.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/bottom_action_bar.dart';
import 'package:rede_campo_online/core/ui/widgets/confirmation_dialog.dart';
import 'package:rede_campo_online/core/ui/widgets/gradient_header.dart';
import 'package:rede_campo_online/core/ui/widgets/date_picker.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import 'package:rede_campo_online/core/ui/forms/entity_picker_field.dart';
import 'package:rede_campo_online/core/ui/forms/media_upload_field.dart';
import 'package:rede_campo_online/features/admin/events/stores/admin_create_event_store.dart';
import 'package:rede_campo_online/core/models/addresses.dart';
import 'package:rede_campo_online/features/events/models/events.dart';
import 'package:rede_campo_online/features/projects/models/projects.dart';

class AdminCreateEventScreen extends StatefulWidget {
  const AdminCreateEventScreen({super.key, this.event});

  final Events? event;

  @override
  State<AdminCreateEventScreen> createState() => _AdminCreateEventScreenState();
}

class _AdminCreateEventScreenState extends State<AdminCreateEventScreen> {
  late final bool editing;
  late final AdminCreateEventStore _createEventStore;
  late final ReactionDisposer _whenDisposer;
  late final ReactionDisposer _errorDisposer;

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _registrationUrlController;

  @override
  void initState() {
    super.initState();
    editing = widget.event != null;
    _createEventStore = AdminCreateEventStore(widget.event ?? Events());

    _nameController = TextEditingController(text: widget.event?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.event?.description ?? '');
    _registrationUrlController =
        TextEditingController(text: widget.event?.registration_url ?? '');

    _nameController
        .addListener(() => _createEventStore.setName(_nameController.text));
    _descriptionController.addListener(
        () => _createEventStore.setDescription(_descriptionController.text));
    _registrationUrlController.addListener(() =>
        _createEventStore.setRegistrationUrl(_registrationUrlController.text));

    _whenDisposer = when(
      (_) => _createEventStore.savedOrUpdatedOrDeleted,
      () {
        if (mounted) context.pop(true);
      },
    );

    _errorDisposer = reaction(
      (_) => _createEventStore.error,
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
    _registrationUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    await openCalendar(
      context: context,
      initialDate: _createEventStore.date,
      onDateSelected: (date) => _createEventStore.setDate(date),
    );
  }

  Future<void> _handleSave() async {
    _createEventStore.invalidSendPressed();
    if (!_createEventStore.isFormValid) return;
    if (editing) {
      await _createEventStore.editEvent();
    } else {
      await _createEventStore.createEvent();
    }
  }

  Future<void> _handleDelete() async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Apagar Evento',
      message:
          'Tem certeza que deseja apagar este evento? Esta ação não pode ser desfeita.',
      confirmLabel: 'Apagar',
    );

    if (confirmed == true) {
      await _createEventStore.deleteEvent();
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
                title: editing ? 'Editar Evento' : 'Novo Evento',
                subtitle: editing
                    ? 'Edite os campos abaixo e salve as alterações.'
                    : 'Preencha os campos abaixo para publicar um novo evento.',
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
                                  label: 'Nome do Evento',
                                  controller: _nameController,
                                  prefixIcon: Icons.title_rounded,
                                  textInputAction: TextInputAction.next,
                                  validator: (_) => _createEventStore.nameError,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  label: 'Descrição',
                                  controller: _descriptionController,
                                  prefixIcon: Icons.short_text_rounded,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  maxLines: 6,
                                  minLines: 3,
                                  validator: (_) =>
                                      _createEventStore.descriptionError,
                                ),
                                const SizedBox(height: 16),
                                DatePickerField(
                                  selectedDate: _createEventStore.date,
                                  onTap: _pickDate,
                                  errorText: _createEventStore.dateError,
                                  placeholder: 'Data do evento',
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  label: 'Link de Inscrição (opcional)',
                                  controller: _registrationUrlController,
                                  prefixIcon: Icons.link_rounded,
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.next,
                                  validator: (_) =>
                                      _createEventStore.registrationUrlError,
                                ),
                                const SizedBox(height: 16),
                                EntityPickerField<Projects>(
                                  label: 'Projeto',
                                  icon: Icons.science_outlined,
                                  items: _createEventStore.availableProjects
                                      .toList(),
                                  itemId: (project) => project.id,
                                  itemLabel: (project) => project.name ?? '—',
                                  selected: _createEventStore.project,
                                  onChanged: _createEventStore.setProject,
                                  searchHint: 'Pesquisar projetos',
                                  emptyLabel: 'Nenhum projeto selecionado',
                                  emptyMessage: 'Nenhum projeto disponível.',
                                  errorText: _createEventStore.projectError,
                                ),
                                const SizedBox(height: 16),
                                EntityPickerField<Addresses>(
                                  label: 'Endereço',
                                  icon: Icons.location_on_outlined,
                                  items: _createEventStore.availableAddresses
                                      .toList(),
                                  itemId: (address) => address.id,
                                  itemLabel: formattedAddress,
                                  selected: _createEventStore.address,
                                  onChanged: _createEventStore.setAddress,
                                  searchHint: 'Pesquisar endereços',
                                  emptyLabel: 'Nenhum endereço selecionado',
                                  emptyMessage: 'Nenhum endereço disponível.',
                                  errorText: _createEventStore.addressError,
                                ),
                                const SizedBox(height: 16),
                                Observer(
                                  builder: (_) => MediaUploadField(
                                    existingItems: _createEventStore
                                        .existingMedia
                                        .toList(),
                                    items:
                                        _createEventStore.pendingMedia.toList(),
                                    onPickImage:
                                        _createEventStore.addPendingMedia,
                                    onRemove:
                                        _createEventStore.removePendingMedia,
                                    onNameChanged:
                                        _createEventStore.setPendingMediaName,
                                    onDeleteExisting:
                                        _createEventStore.deleteExistingMedia,
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
                          loading: _createEventStore.loading,
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
