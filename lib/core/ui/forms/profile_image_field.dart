import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../global/constants/api_constants.dart';
import '../theme/custom_colors.dart';
import 'form_field_shell.dart';

/// Campo de upload de uma única imagem (ex.: foto de perfil de um membro).
/// Exibe a imagem já persistida ([existingImageUrl]) ou a recém-selecionada
/// ([pickedFile]) em um avatar circular, delegando as mutações ao chamador.
class ProfileImageField extends StatefulWidget {
  const ProfileImageField({
    super.key,
    this.label = 'Foto de Perfil',
    this.existingImageUrl,
    this.pickedFile,
    required this.onPick,
    required this.onRemove,
    this.errorText,
  });

  final String label;
  final String? existingImageUrl;
  final XFile? pickedFile;
  final void Function(XFile file) onPick;
  final VoidCallback onRemove;
  final String? errorText;

  @override
  State<ProfileImageField> createState() => _ProfileImageFieldState();
}

class _ProfileImageFieldState extends State<ProfileImageField> {
  final _picker = ImagePicker();
  Future<Uint8List>? _thumbnail;
  XFile? _thumbnailSource;

  bool get _hasExisting =>
      widget.existingImageUrl != null && widget.existingImageUrl!.isNotEmpty;

  bool get _hasImage => widget.pickedFile != null || _hasExisting;

  Future<Uint8List> _thumbnailFor(XFile file) {
    if (_thumbnailSource != file) {
      _thumbnailSource = file;
      _thumbnail = file.readAsBytes();
    }
    return _thumbnail!;
  }

  String get _existingUrl {
    final url = widget.existingImageUrl!;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return '$baseURL/${url.startsWith('/') ? url.substring(1) : url}';
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (picked != null) widget.onPick(picked);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldShell(
          label: widget.label,
          actionIcon: Icons.add_photo_alternate_outlined,
          actionLabel: _hasImage ? 'Alterar' : 'Selecionar',
          onAction: _pickImage,
          child: _hasImage
              ? FormFieldContentBox(
                  padding: const EdgeInsets.all(12),
                  borderColor: hasError
                      ? CustomColors.danger_red
                      : CustomColors.soft_border,
                  child: Row(
                    children: [
                      _Avatar(child: _buildPreview()),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.pickedFile != null
                              ? widget.pickedFile!.name
                              : 'Imagem atual',
                          style: const TextStyle(
                            fontSize: 13,
                            color: CustomColors.midnight_slate,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: widget.onRemove,
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        color: CustomColors.copper_spice,
                        style: IconButton.styleFrom(
                          backgroundColor: CustomColors.danger_surface,
                          minimumSize: const Size(34, 34),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                )
              : FormFieldEmptyState(
                  icon: Icons.person_outline_rounded,
                  message: 'Nenhuma foto selecionada',
                  hasError: hasError,
                ),
        ),
        if (hasError) FieldErrorText(message: widget.errorText!),
      ],
    );
  }

  Widget _buildPreview() {
    if (widget.pickedFile != null) {
      return FutureBuilder<Uint8List>(
        future: _thumbnailFor(widget.pickedFile!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(snapshot.data!, fit: BoxFit.cover);
          }
          return _placeholder();
        },
      );
    }
    if (_hasExisting) {
      return Image.network(
        _existingUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        color: CustomColors.placeholder_surface,
        child: const Icon(Icons.person_rounded,
            size: 26, color: CustomColors.placeholder_icon),
      );
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(width: 54, height: 54, child: child),
    );
  }
}
