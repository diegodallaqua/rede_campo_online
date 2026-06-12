import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/ui/forms/custom_text_field.dart';
import 'package:rede_campo_online/core/ui/forms/entity_picker_field.dart';
import 'package:rede_campo_online/core/models/organizations.dart';
import 'package:rede_campo_online/features/admin/publications/models/publication_type.dart';
import 'package:rede_campo_online/features/admin/publications/screens/widgets/form/book_cover_upload_field.dart';
import 'package:rede_campo_online/features/admin/publications/screens/widgets/form/publication_form_controllers.dart';
import 'package:rede_campo_online/features/admin/publications/stores/admin_create_publication_store.dart';

/// Campos específicos do tipo de publicação selecionado (artigo, livro,
/// capítulo de livro ou tese). Reage à troca de tipo no store.
class PublicationTypeFormFields extends StatelessWidget {
  const PublicationTypeFormFields({
    super.key,
    required this.store,
    required this.controllers,
  });

  final AdminCreatePublicationStore store;
  final PublicationFormControllers controllers;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildFields(),
      ),
    );
  }

  List<Widget> _buildFields() {
    switch (store.publicationType) {
      case PublicationType.article:
        return _articleFields();
      case PublicationType.book:
        return _bookFields();
      case PublicationType.bookChapter:
        return _bookChapterFields();
      case PublicationType.thesis:
        return _thesisFields();
      case null:
        return const [];
    }
  }

  List<Widget> _articleFields() {
    return [
      const SizedBox(height: 16),
      CustomTextField(
        label: 'Nome do Periódico',
        controller: controllers.journalName,
        prefixIcon: Icons.menu_book_outlined,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.always,
        validator: (_) => store.journalNameError,
      ),
      const SizedBox(height: 16),
      CustomTextField(
        label: 'Volume (opcional)',
        controller: controllers.volume,
        prefixIcon: Icons.bookmark_border_rounded,
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(height: 16),
      CustomTextField(
        label: 'Edição (opcional)',
        controller: controllers.issue,
        prefixIcon: Icons.numbers_rounded,
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(height: 16),
      CustomTextField(
        label: 'Páginas (opcional)',
        controller: controllers.pages,
        prefixIcon: Icons.auto_stories_outlined,
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(height: 16),
      CustomTextField(
        label: 'Editora (opcional)',
        controller: controllers.articlePublisher,
        prefixIcon: Icons.business_outlined,
        textInputAction: TextInputAction.done,
      ),
    ];
  }

  List<Widget> _bookFields() {
    return [
      const SizedBox(height: 16),
      CustomTextField(
        label: 'Editora',
        controller: controllers.bookPublisher,
        prefixIcon: Icons.business_outlined,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.always,
        validator: (_) => store.bookPublisherError,
      ),
      const SizedBox(height: 16),
      CustomTextField(
        label: 'Edição',
        controller: controllers.edition,
        prefixIcon: Icons.numbers_rounded,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.always,
        validator: (_) => store.editionError,
      ),
      const SizedBox(height: 16),
      CustomTextField(
        label: 'ISBN',
        controller: controllers.isbn,
        prefixIcon: Icons.qr_code_2_rounded,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.always,
        validator: (_) => store.isbnError,
      ),
      const SizedBox(height: 16),
      Observer(
        builder: (_) => BookCoverUploadField(
          file: store.coverPhotoFile,
          existingUrl: store.existingCoverPhoto,
          onPickImage: store.setCoverPhotoFile,
          onRemove: () => store.setCoverPhotoFile(null),
        ),
      ),
      const SizedBox(height: 16),
      CustomTextField(
        label: 'URL do Livro (opcional)',
        controller: controllers.bookUrl,
        prefixIcon: Icons.link_rounded,
        keyboardType: TextInputType.url,
        textInputAction: TextInputAction.done,
        autovalidateMode: AutovalidateMode.always,
        validator: (_) => store.bookUrlError,
      ),
    ];
  }

  List<Widget> _bookChapterFields() {
    return [
      const SizedBox(height: 16),
      CustomTextField(
        label: 'Nome do Livro',
        controller: controllers.bookName,
        prefixIcon: Icons.menu_book_outlined,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.always,
        validator: (_) => store.bookNameError,
      ),
      const SizedBox(height: 16),
      CustomTextField(
        label: 'Número do Capítulo',
        controller: controllers.chapterNumber,
        prefixIcon: Icons.numbers_rounded,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        autovalidateMode: AutovalidateMode.always,
        validator: (_) => store.chapterNumberError,
      ),
    ];
  }

  List<Widget> _thesisFields() {
    return [
      const SizedBox(height: 16),
      Observer(
        builder: (_) => EntityPickerField<Organizations>(
          label: 'Organização',
          icon: Icons.account_balance_outlined,
          items: store.availableOrganizations.toList(),
          itemId: (organization) => organization.id,
          itemLabel: (organization) => organization.name ?? '—',
          selected: store.organization,
          onChanged: store.setOrganization,
          searchHint: 'Pesquisar organização',
          emptyLabel: 'Nenhuma organização selecionada',
          emptyMessage: 'Nenhuma organização disponível.',
          errorText: store.organizationError,
        ),
      ),
      const SizedBox(height: 16),
      CustomTextField(
        label: 'Número de Páginas',
        controller: controllers.numberOfPages,
        prefixIcon: Icons.auto_stories_outlined,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        autovalidateMode: AutovalidateMode.always,
        validator: (_) => store.numberOfPagesError,
      ),
    ];
  }
}
