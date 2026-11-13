import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

import '../../../utils/placeholders.dart';
import '../../theme/custom_colors.dart';

/// Coluna da tabela: largura fixa com [width], senão [flex].
class AdminTableColumn {
  final String label;
  final double? width;
  final int flex;

  const AdminTableColumn(this.label, {this.width, this.flex = 1});
}

const double _cellGap = 16;
const double _actionWidth = 40;

List<Widget> _layoutCells(List<AdminTableColumn> columns, List<Widget> cells) {
  final children = <Widget>[];
  for (var i = 0; i < columns.length; i++) {
    if (i > 0) children.add(const SizedBox(width: _cellGap));
    final column = columns[i];
    final cell = Align(alignment: Alignment.centerLeft, child: cells[i]);
    children.add(column.width != null
        ? SizedBox(width: column.width, child: cell)
        : Expanded(flex: column.flex, child: cell));
  }
  return children;
}

/// Linha de títulos da tabela.
class AdminTableHeader extends StatelessWidget {
  final List<AdminTableColumn> columns;

  const AdminTableHeader({super.key, required this.columns});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.salt_flower,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          ..._layoutCells(
            columns,
            columns
                .map((c) => Text(
                      c.label.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: CustomColors.midnight_slate.withOpacity(0.75),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(width: _cellGap + _actionWidth),
        ],
      ),
    );
  }
}

/// Linha da tabela; o toque abre a edição.
class AdminTableRow extends StatelessWidget {
  final List<AdminTableColumn> columns;
  final List<Widget> cells;
  final VoidCallback onEdit;

  const AdminTableRow({
    super.key,
    required this.columns,
    required this.cells,
    required this.onEdit,
  }) : assert(columns.length == cells.length);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onEdit,
        hoverColor: CustomColors.honey_cream.withOpacity(0.25),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              ..._layoutCells(columns, cells),
              const SizedBox(width: _cellGap),
              SizedBox(
                width: _actionWidth,
                child: IconButton(
                  tooltip: 'Editar',
                  onPressed: onEdit,
                  style: IconButton.styleFrom(
                    backgroundColor: CustomColors.peach_cream,
                    foregroundColor: CustomColors.copper_spice,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.edit_rounded, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Miniatura da imagem principal, com o mesmo placeholder dos cards.
class AdminTableThumb extends StatelessWidget {
  final String? imageUrl;

  const AdminTableThumb({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 56,
        height: 40,
        child: url != null && url.isNotEmpty
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _ThumbPlaceholder(),
              )
            : const _ThumbPlaceholder(),
      ),
    );
  }
}

class _ThumbPlaceholder extends StatelessWidget {
  const _ThumbPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.pine_shadow.withOpacity(0.2),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        size: 18,
        color: CustomColors.pine_shadow.withOpacity(0.8),
      ),
    );
  }
}

/// Foto do membro ou a inicial do nome.
class AdminTableAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;

  const AdminTableAvatar({super.key, this.imageUrl, this.name});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final placeholder = AvatarPlaceholder(name: name);
    return ClipOval(
      child: SizedBox(
        width: 40,
        height: 40,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: 96,
            height: 96,
            child: url != null && url.isNotEmpty
                ? Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => placeholder,
                  )
                : placeholder,
          ),
        ),
      ),
    );
  }
}

/// Título da linha com texto de apoio opcional.
class AdminTableTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AdminTableTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final sub = subtitle?.trim();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: CustomColors.pine_shadow,
          ),
        ),
        if (sub != null && sub.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            sub,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: CustomColors.midnight_slate.withOpacity(0.75),
            ),
          ),
        ],
      ],
    );
  }
}

/// Texto simples de uma célula (datas, organização, projeto).
class AdminTableText extends StatelessWidget {
  final String? text;

  const AdminTableText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final value = text?.trim();
    return Text(
      value == null || value.isEmpty ? '—' : value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 14,
        color: CustomColors.midnight_slate,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
    );
  }
}

/// Etiquetas da célula: até [maxVisible], o resto vira "+N".
class AdminTableChips extends StatelessWidget {
  final List<String> labels;
  final Color color;
  final int maxVisible;

  const AdminTableChips({
    super.key,
    required this.labels,
    this.color = CustomColors.pine_shadow,
    this.maxVisible = 2,
  });

  @override
  Widget build(BuildContext context) {
    final visible = labels.where((l) => l.isNotEmpty).toList();
    if (visible.isEmpty) return const AdminTableText(null);

    final hidden = visible.length - maxVisible;
    final shown = hidden > 0 ? visible.take(maxVisible).toList() : visible;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final label in shown) ...[
          Flexible(child: _Chip(label: label, color: color)),
          const SizedBox(width: 6),
        ],
        if (hidden > 0) _Chip(label: '+$hidden', color: color),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
