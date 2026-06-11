import 'package:flutter/widgets.dart';
import 'package:rede_campo_online/features/admin/publications/stores/admin_create_publication_store.dart';

/// Controllers de texto do formulário de publicação. Cada controller nasce
/// com o valor atual do store e propaga as digitações de volta para ele,
/// removendo o cabeamento manual que ficava na tela.
class PublicationFormControllers {
  PublicationFormControllers(AdminCreatePublicationStore store)
      : title = _bind(store.title, store.setTitle),
        abstract_ = _bind(store.abstract, store.setAbstract),
        doi = _bind(store.doi, store.setDoi),
        journalName = _bind(store.journalName, store.setJournalName),
        volume = _bind(store.volume, store.setVolume),
        issue = _bind(store.issue, store.setIssue),
        pages = _bind(store.pages, store.setPages),
        articlePublisher =
            _bind(store.articlePublisher, store.setArticlePublisher),
        bookPublisher = _bind(store.bookPublisher, store.setBookPublisher),
        edition = _bind(store.edition, store.setEdition),
        isbn = _bind(store.isbn, store.setIsbn),
        bookUrl = _bind(store.bookUrl, store.setBookUrl),
        bookName = _bind(store.bookName, store.setBookName),
        chapterNumber = _bind(store.chapterNumber, store.setChapterNumber),
        numberOfPages = _bind(store.numberOfPages, store.setNumberOfPages);

  final TextEditingController title;
  final TextEditingController abstract_;
  final TextEditingController doi;

  // Artigo
  final TextEditingController journalName;
  final TextEditingController volume;
  final TextEditingController issue;
  final TextEditingController pages;
  final TextEditingController articlePublisher;

  // Livro
  final TextEditingController bookPublisher;
  final TextEditingController edition;
  final TextEditingController isbn;
  final TextEditingController bookUrl;

  // Capítulo de Livro
  final TextEditingController bookName;
  final TextEditingController chapterNumber;

  // Tese
  final TextEditingController numberOfPages;

  static TextEditingController _bind(
    String initialValue,
    void Function(String) onChanged,
  ) {
    final controller = TextEditingController(text: initialValue);
    controller.addListener(() => onChanged(controller.text));
    return controller;
  }

  List<TextEditingController> get _all => [
        title,
        abstract_,
        doi,
        journalName,
        volume,
        issue,
        pages,
        articlePublisher,
        bookPublisher,
        edition,
        isbn,
        bookUrl,
        bookName,
        chapterNumber,
        numberOfPages,
      ];

  /// Preenche os controllers dos campos específicos do tipo a partir do
  /// store. Usado na edição quando o tipo é detectado de forma assíncrona.
  void syncTypeFields(AdminCreatePublicationStore store) {
    journalName.text = store.journalName;
    volume.text = store.volume;
    issue.text = store.issue;
    pages.text = store.pages;
    articlePublisher.text = store.articlePublisher;
    bookPublisher.text = store.bookPublisher;
    edition.text = store.edition;
    isbn.text = store.isbn;
    bookUrl.text = store.bookUrl;
    bookName.text = store.bookName;
    chapterNumber.text = store.chapterNumber;
    numberOfPages.text = store.numberOfPages;
  }

  void dispose() {
    for (final controller in _all) {
      controller.dispose();
    }
  }
}
