import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';

/// Diálogo genérico de seleção única com barra de pesquisa, seguindo o mesmo
/// layout do ResearchAreasDialog. Usado para escolher o projeto e o endereço
/// de um evento.
class EntityPickerDialog<T> extends StatefulWidget {
  const EntityPickerDialog({
    super.key,
    required this.title,
    required this.items,
    required this.itemId,
    required this.itemLabel,
    this.itemSubtitle,
    this.selected,
    this.searchHint = 'Pesquisar',
    this.emptyMessage = 'Nenhum item disponível.',
  });

  final String title;
  final List<T> items;
  final int? Function(T item) itemId;
  final String Function(T item) itemLabel;
  final String? Function(T item)? itemSubtitle;
  final T? selected;
  final String searchHint;
  final String emptyMessage;

  /// Exibe o Dialog e retorna a seleção confirmada, ou null se cancelado.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required int? Function(T item) itemId,
    required String Function(T item) itemLabel,
    String? Function(T item)? itemSubtitle,
    T? selected,
    String searchHint = 'Pesquisar',
    String emptyMessage = 'Nenhum item disponível.',
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => EntityPickerDialog<T>(
        title: title,
        items: items,
        itemId: itemId,
        itemLabel: itemLabel,
        itemSubtitle: itemSubtitle,
        selected: selected,
        searchHint: searchHint,
        emptyMessage: emptyMessage,
      ),
    );
  }

  @override
  State<EntityPickerDialog<T>> createState() => _EntityPickerDialogState<T>();
}

class _EntityPickerDialogState<T> extends State<EntityPickerDialog<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  T? _selected;

  @override
  void initState() {
    super.initState();
    // Resolve a seleção para a instância presente na lista (igualdade por id),
    final selected = widget.selected;
    if (selected != null) {
      final selectedId = widget.itemId(selected);
      _selected = widget.items.cast<T?>().firstWhere(
            (item) => item != null && widget.itemId(item) == selectedId,
            orElse: () => selected,
          );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query.trim().toLowerCase());
  }

  List<T> get _filteredItems {
    if (_searchQuery.isEmpty) return widget.items;
    return widget.items
        .where((item) =>
            widget.itemLabel(item).toLowerCase().contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: CustomColors.midnight_slate,
          fontSize: 17,
        ),
      ),
      content: widget.items.isEmpty
          ? Text(
              widget.emptyMessage,
              style: const TextStyle(
                  color: CustomColors.neutral_gray, fontSize: 14, height: 1.5),
            )
          : SizedBox(
              // Tamanho fixo para o diálogo não encolher conforme a pesquisa
              // filtra os resultados.
              height: MediaQuery.sizeOf(context).height * 0.6,
              width: 400,
              child: Column(
                children: [
                  CustomSearchBar(
                    controller: _searchController,
                    onSubmitted: _onSearch,
                    hintText: widget.searchHint,
                    borderColor: CustomColors.soft_border,
                    textColor: CustomColors.midnight_slate,
                    hintColor: CustomColors.midnight_slate.withOpacity(0.45),
                    iconColor: CustomColors.midnight_slate.withOpacity(0.45),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _filteredItems.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Nenhum resultado encontrado',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CustomColors.midnight_slate
                                      .withOpacity(0.45),
                                ),
                              ),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: _filteredItems.map((item) {
                                final subtitle =
                                    widget.itemSubtitle?.call(item);
                                return RadioListTile<T>(
                                  value: item,
                                  groupValue: _selected,
                                  onChanged: (value) =>
                                      setState(() => _selected = value),
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  activeColor: CustomColors.copper_spice,
                                  title: Text(
                                    widget.itemLabel(item),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: CustomColors.midnight_slate,
                                    ),
                                  ),
                                  subtitle: (subtitle != null &&
                                          subtitle.isNotEmpty)
                                      ? Text(
                                          subtitle,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: CustomColors.midnight_slate
                                                .withOpacity(0.5),
                                          ),
                                        )
                                      : null,
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: CustomColors.neutral_gray),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.copper_spice,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          onPressed: _selected != null
              ? () => Navigator.of(context).pop(_selected)
              : null,
          child: const Text(
            'Confirmar',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
