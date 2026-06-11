import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rede_campo_online/core/ui/forms/form_field_shell.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

/// Campo de upload da capa do livro. Imagem única escolhida da galeria,
/// enviada ao Cloudflare durante o salvamento da publicação.
class BookCoverUploadField extends StatefulWidget {
  const BookCoverUploadField({
    super.key,
    required this.file,
    required this.onPickImage,
    required this.onRemove,
    this.existingUrl,
  });

  final XFile? file;
  final void Function(XFile file) onPickImage;
  final VoidCallback onRemove;

  /// Capa já salva no servidor (edição). Exibida enquanto nenhuma nova imagem
  /// é escolhida.
  final String? existingUrl;

  @override
  State<BookCoverUploadField> createState() => _BookCoverUploadFieldState();
}

class _BookCoverUploadFieldState extends State<BookCoverUploadField> {
  final _picker = ImagePicker();
  Future<Uint8List>? _thumbnail;
  XFile? _thumbnailFile;

  Future<Uint8List> _thumbnailFor(XFile file) {
    if (_thumbnailFile != file) {
      _thumbnailFile = file;
      _thumbnail = file.readAsBytes();
    }
    return _thumbnail!;
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (picked != null) widget.onPickImage(picked);
  }

  @override
  Widget build(BuildContext context) {
    final file = widget.file;
    final existingUrl = widget.existingUrl;
    final hasExisting =
        file == null && existingUrl != null && existingUrl.isNotEmpty;

    final Widget content;
    if (hasExisting) {
      content = _CoverPreviewBox(
        image: Image.network(
          existingUrl,
          width: 54,
          height: 54,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const _CoverThumbnailFallback(),
        ),
        label: Text(
          'Capa atual',
          style: TextStyle(
            fontSize: 13,
            color: CustomColors.midnight_slate.withOpacity(0.7),
          ),
        ),
      );
    } else if (file == null) {
      content = const FormFieldEmptyState(
        icon: Icons.photo_library_outlined,
        message: 'Nenhuma capa adicionada',
      );
    } else {
      content = _CoverPreviewBox(
        image: FutureBuilder<Uint8List>(
          future: _thumbnailFor(file),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.memory(
                snapshot.data!,
                width: 54,
                height: 54,
                fit: BoxFit.cover,
              );
            }
            return const _CoverThumbnailFallback();
          },
        ),
        label: Text(
          file.name,
          style: const TextStyle(
            fontSize: 13,
            color: CustomColors.midnight_slate,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          onPressed: widget.onRemove,
          icon: const Icon(Icons.close_rounded, size: 18),
          color: CustomColors.copper_spice,
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFFFF1F0),
            minimumSize: const Size(34, 34),
            padding: EdgeInsets.zero,
          ),
        ),
      );
    }

    return FormFieldShell(
      label: 'Capa do Livro',
      actionIcon: Icons.add_photo_alternate_outlined,
      actionLabel: file == null && !hasExisting ? 'Adicionar' : 'Alterar',
      onAction: _pickImage,
      child: content,
    );
  }
}

/// Caixa branca com a miniatura da capa, um rótulo e uma ação opcional.
class _CoverPreviewBox extends StatelessWidget {
  const _CoverPreviewBox({
    required this.image,
    required this.label,
    this.trailing,
  });

  final Widget image;
  final Widget label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return FormFieldContentBox(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: image,
          ),
          const SizedBox(width: 10),
          Expanded(child: label),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _CoverThumbnailFallback extends StatelessWidget {
  const _CoverThumbnailFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      color: const Color(0xFFF0F0E8),
      child: const Icon(
        Icons.image_outlined,
        size: 22,
        color: Color(0xFFBBBBAA),
      ),
    );
  }
}
