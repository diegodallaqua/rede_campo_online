import 'package:image_picker/image_picker.dart';

/// Imagem selecionada ainda não enviada ao servidor.
class PendingMedia {
  final XFile file;
  String name;

  PendingMedia({required this.file, this.name = ''});
}
