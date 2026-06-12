import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/media_attachment.dart';
import '../../models/pending_media.dart';
import '../theme/custom_colors.dart';

/// Campo de upload de imagens usado nos formulários do painel administrativo.
/// Exibe as mídias já persistidas ([existingItems]) e as recém-selecionadas
/// ([items]), delegando todas as mutações ao chamador via callbacks.
class MediaUploadField extends StatefulWidget {
  const MediaUploadField({
    super.key,
    this.existingItems = const [],
    required this.items,
    required this.onPickImage,
    required this.onRemove,
    required this.onNameChanged,
    this.onDeleteExisting,
  });

  final List<MediaAttachment> existingItems;
  final List<PendingMedia> items;
  final void Function(XFile file) onPickImage;
  final void Function(int index) onRemove;
  final void Function(int index, String name) onNameChanged;
  final void Function(int index)? onDeleteExisting;

  @override
  State<MediaUploadField> createState() => _MediaUploadFieldState();
}

class _MediaUploadFieldState extends State<MediaUploadField> {
  final _picker = ImagePicker();
  final Map<PendingMedia, TextEditingController> _controllers = {};
  final Map<PendingMedia, Future<Uint8List>> _thumbnails = {};

  TextEditingController _controllerFor(PendingMedia item) {
    return _controllers.putIfAbsent(
      item,
      () => TextEditingController(text: item.name),
    );
  }

  Future<Uint8List> _thumbnailFor(PendingMedia item) {
    return _thumbnails.putIfAbsent(item, () => item.file.readAsBytes());
  }

  @override
  void didUpdateWidget(MediaUploadField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final current = widget.items.toSet();
    _controllers.removeWhere((item, ctrl) {
      if (!current.contains(item)) {
        ctrl.dispose();
        return true;
      }
      return false;
    });
    _thumbnails.removeWhere((item, _) => !current.contains(item));
  }

  @override
  void dispose() {
    for (final ctrl in _controllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (picked != null) widget.onPickImage(picked);
  }

  bool get _isEmpty => widget.existingItems.isEmpty && widget.items.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Imagens',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: CustomColors.midnight_slate,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
              label: const Text('Adicionar'),
              style: TextButton.styleFrom(
                foregroundColor: CustomColors.copper_spice,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (_isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: CustomColors.vanilla_haze.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CustomColors.soft_border),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 28,
                  color: CustomColors.midnight_slate.withOpacity(0.25),
                ),
                const SizedBox(height: 6),
                Text(
                  'Nenhuma imagem adicionada',
                  style: TextStyle(
                    fontSize: 13,
                    color: CustomColors.midnight_slate.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              ...List.generate(widget.existingItems.length, (i) {
                final media = widget.existingItems[i];
                return _ExistingMediaItem(
                  key: ValueKey(media.id),
                  media: media,
                  onDelete: widget.onDeleteExisting != null
                      ? () => widget.onDeleteExisting!(i)
                      : null,
                );
              }),
              ...List.generate(widget.items.length, (i) {
                final item = widget.items[i];
                return _PendingMediaItem(
                  key: ObjectKey(item),
                  thumbnailFuture: _thumbnailFor(item),
                  controller: _controllerFor(item),
                  onRemove: () => widget.onRemove(i),
                  onNameChanged: (name) {
                    item.name = name;
                    widget.onNameChanged(i, name);
                  },
                );
              }),
            ],
          ),
      ],
    );
  }
}

class _ExistingMediaItem extends StatelessWidget {
  const _ExistingMediaItem({
    super.key,
    required this.media,
    this.onDelete,
  });

  final MediaAttachment media;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: CustomColors.salt_flower,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CustomColors.soft_border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: media.media != null && media.media!.isNotEmpty
                ? Image.network(
                    media.media!,
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              media.name ?? '—',
              style: const TextStyle(
                fontSize: 13,
                color: CustomColors.midnight_slate,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          if (onDelete != null)
            IconButton(
              onPressed: onDelete,
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
    );
  }

  Widget _placeholder() => Container(
        width: 54,
        height: 54,
        color: CustomColors.placeholder_surface,
        child: const Icon(Icons.image_outlined,
            size: 22, color: CustomColors.placeholder_icon),
      );
}

class _PendingMediaItem extends StatelessWidget {
  const _PendingMediaItem({
    super.key,
    required this.thumbnailFuture,
    required this.controller,
    required this.onRemove,
    required this.onNameChanged,
  });

  final Future<Uint8List> thumbnailFuture;
  final TextEditingController controller;
  final VoidCallback onRemove;
  final void Function(String) onNameChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CustomColors.soft_border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: FutureBuilder<Uint8List>(
              future: thumbnailFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(
                    snapshot.data!,
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                  );
                }
                return Container(
                  width: 54,
                  height: 54,
                  color: CustomColors.placeholder_surface,
                  child: const Icon(Icons.image_outlined,
                      size: 22, color: CustomColors.placeholder_icon),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onNameChanged,
              style: const TextStyle(
                fontSize: 13,
                color: CustomColors.midnight_slate,
              ),
              decoration: InputDecoration(
                hintText: 'Nome da imagem',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: CustomColors.midnight_slate.withOpacity(0.4),
                ),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: CustomColors.soft_border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: CustomColors.soft_border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide:
                      const BorderSide(color: CustomColors.copper_spice),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close_rounded, size: 18),
            color: CustomColors.copper_spice,
            style: IconButton.styleFrom(
              backgroundColor: CustomColors.danger_surface,
              minimumSize: const Size(34, 34),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
