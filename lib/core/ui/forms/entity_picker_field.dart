import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/forms/form_field_shell.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/dialogs/entity_picker_dialog.dart';

/// Campo genérico de seleção única que abre um EntityPickerDialog com barra
/// de pesquisa, no mesmo padrão visual do ResearchAreasField. Usado para os
/// campos de projeto/endereço do evento e organização da tese.
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldShell(
          label: label,
          actionIcon: Icons.tune_rounded,
          actionLabel: selected == null ? 'Selecionar' : 'Alterar',
          onAction: () => _openDialog(context),
          child: selected == null
              ? FormFieldEmptyState(
                  icon: icon,
                  message: emptyLabel,
                  hasError: hasError,
                )
              : FormFieldContentBox(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  borderColor: hasError
                      ? CustomColors.danger_red
                      : CustomColors.soft_border,
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
        ),
        if (hasError) FieldErrorText(message: errorText!),
      ],
    );
  }
}
