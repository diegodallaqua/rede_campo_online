import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';

import '../../../../../core/ui/widgets/dialogs/entity_picker_dialog.dart';

/// Campo genérico de seleção única que abre um EntityPickerDialog com barra
/// de pesquisa, no mesmo padrão visual do ResearchAreasField. Usado para os
/// campos de projeto e endereço do evento.
class EntityPickerField<T> extends StatelessWidget {
  const EntityPickerField({
    super.key,
    required this.label,
    required this.icon,
    required this.items,
    required this.itemId,
    required this.itemLabel,
    required this.selected,
    required this.onChanged,
    this.itemSubtitle,
    this.searchHint = 'Pesquisar',
    this.emptyLabel = 'Nenhum item selecionado',
    this.emptyMessage = 'Nenhum item disponível.',
    this.errorText,
  });

  final String label;
  final IconData icon;
  final List<T> items;
  final int? Function(T item) itemId;
  final String Function(T item) itemLabel;
  final String? Function(T item)? itemSubtitle;
  final T? selected;
  final void Function(T) onChanged;
  final String searchHint;
  final String emptyLabel;
  final String emptyMessage;
  final String? errorText;

  Future<void> _openDialog(BuildContext context) async {
    final result = await EntityPickerDialog.show<T>(
      context: context,
      title: label,
      items: items,
      itemId: itemId,
      itemLabel: itemLabel,
      itemSubtitle: itemSubtitle,
      selected: selected,
      searchHint: searchHint,
      emptyMessage: emptyMessage,
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final borderColor =
        hasError ? const Color(0xFFCF1322) : const Color(0xFFE2E2DC);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: CustomColors.midnight_slate,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => _openDialog(context),
              icon: const Icon(Icons.tune_rounded, size: 18),
              label: Text(selected == null ? 'Selecionar' : 'Alterar'),
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
        if (selected == null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: CustomColors.vanilla_haze.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: borderColor,
                width: hasError ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: CustomColors.midnight_slate.withOpacity(0.25),
                ),
                const SizedBox(height: 6),
                Text(
                  emptyLabel,
                  style: TextStyle(
                    fontSize: 13,
                    color: CustomColors.midnight_slate.withOpacity(0.45),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: CustomColors.vanilla_haze.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: CustomColors.midnight_slate.withOpacity(0.38),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    itemLabel(selected as T),
                    style: const TextStyle(
                      fontSize: 14,
                      color: CustomColors.midnight_slate,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              errorText!,
              style: const TextStyle(color: Color(0xFFCF1322), fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}
