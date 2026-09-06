import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rede_campo_online/core/ui/forms/custom_text_field.dart';
import 'package:rede_campo_online/core/ui/forms/entity_picker_field.dart';
import 'package:rede_campo_online/core/ui/widgets/date_picker.dart';
import 'package:rede_campo_online/core/models/academic_work_types.dart';
import 'package:rede_campo_online/core/models/organizations.dart';
import 'package:rede_campo_online/features/books/models/books.dart';
import 'package:rede_campo_online/features/admin/publications/models/publication_type.dart';
import 'package:rede_campo_online/features/admin/publications/screens/widgets/form/book_cover_upload_field.dart';
import 'package:rede_campo_online/features/admin/publications/screens/widgets/form/publication_form_controllers.dart';
import 'package:rede_campo_online/features/admin/publications/stores/admin_create_publication_store.dart';

/// Campos específicos do tipo de publicação selecionado (artigo, livro,
/// capítulo de livro ou trabalho acadêmico). Reage à troca de tipo no store.
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
        children: _buildFields(context),
      ),
    );
  }

  List<Widget> _buildFields(BuildContext context) {
    switch (store.publicationType) {
      case PublicationType.article:
        return _articleFields();
      case PublicationType.book:
        return _bookFields();
      case PublicationType.bookChapter:
        return _bookChapterFields();
      case PublicationType.academicWork:
        return _academicWorkFields(context);
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
      Observer(
        builder: (_) => EntityPickerField<Books>(
          label: 'Livro Cadastrado (opcional)',
          icon: Icons.library_books_outlined,
          items: store.availableBooks.toList(),
          itemId: (book) => book.publication?.id,
          itemLabel: (book) => book.publication?.title ?? '-',
          itemSubtitle: (book) =>
              book.isbn?.isNotEmpty == true ? 'ISBN: ${book.isbn}' : null,
          selected: store.book,
          onChanged: store.setBook,
          onClear: () => store.setBook(null),
          searchHint: 'Pesquisar livro',
          emptyLabel: 'Nenhum livro vinculado',
          emptyMessage: 'Nenhum livro disponível.',
        ),
      ),
      // Com um livro vinculado, nome e ISBN exibidos passam a ser os dele, de
      // modo que os campos equivalentes do capítulo são ocultados.
      if (!store.hasLinkedBook) ...[
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Nome do Livro',
          controller: controllers.bookName,
          prefixIcon: Icons.menu_book_outlined,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.always,
          validator: (_) => store.bookNameError,
        ),
      ],
      const SizedBox(height: 16),
      CustomTextField(
        label: 'Número do Capítulo',
        controller: controllers.chapterNumber,
        prefixIcon: Icons.numbers_rounded,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.always,
        validator: (_) => store.chapterNumberError,
      ),
      const SizedBox(height: 16),
      CustomTextField(
        label: 'Página Inicial (opcional)',
        controller: controllers.startPage,
        prefixIcon: Icons.first_page_rounded,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.always,
        validator: (_) => store.startPageError,
      ),
      const SizedBox(height: 16),
      CustomTextField(
        label: 'Página Final (opcional)',
        controller: controllers.endPage,
        prefixIcon: Icons.last_page_rounded,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.always,
        validator: (_) => store.endPageError,
      ),
      if (!store.hasLinkedBook) ...[
        const SizedBox(height: 16),
        CustomTextField(
          label: 'ISBN (opcional)',
          controller: controllers.chapterIsbn,
          prefixIcon: Icons.qr_code_2_rounded,
          textInputAction: TextInputAction.done,
          autovalidateMode: AutovalidateMode.always,
          validator: (_) => store.chapterIsbnError,
        ),
      ],
    ];
  }

  List<Widget> _academicWorkFields(BuildContext context) {
    return [
      const SizedBox(height: 16),
      Observer(
        builder: (_) => EntityPickerField<AcademicWorkType>(
          label: 'Tipo de Trabalho Acadêmico',
          icon: Icons.school_outlined,
          items: store.availableAcademicWorkTypes.toList(),
          itemId: (type) => type.id,
          itemLabel: (type) => type.label,
          selected: store.academicWorkType,
          onChanged: store.setAcademicWorkType,
          searchHint: 'Pesquisar tipo de trabalho acadêmico',
          emptyLabel: 'Nenhum tipo selecionado',
          emptyMessage: 'Nenhum tipo de trabalho acadêmico disponível.',
          errorText: store.academicWorkTypeError,
        ),
      ),
      const SizedBox(height: 16),
      Observer(
        builder: (_) => EntityPickerField<Organizations>(
          label: 'Organização',
          icon: Icons.account_balance_outlined,
          items: store.availableOrganizations.toList(),
          itemId: (organization) => organization.id,
          itemLabel: (organization) => organization.name ?? '-',
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
      const SizedBox(height: 16),
      Observer(
        builder: (_) => DatePickerField(
          selectedDate: store.defenseDate,
          placeholder: 'Data de defesa',
          errorText: store.defenseDateError,
          onTap: () => openCalendar(
            context: context,
            initialDate: store.defenseDate,
            onDateSelected: store.setDefenseDate,
            firstDate: DateTime(1900),
          ),
        ),
      ),
    ];
  }
}
