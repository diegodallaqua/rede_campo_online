import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/models/project_types.dart';

class ProjectTypeField extends StatelessWidget {
  const ProjectTypeField({
    super.key,
    required this.availableTypes,
    required this.selectedType,
    required this.onChanged,
    this.errorText,
  });

  final List<ProjectTypes> availableTypes;
  final ProjectTypes? selectedType;
  final void Function(ProjectTypes?) onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    // Garante que o valor selecionado seja a mesma instância presente na lista
    // (igualdade por identidade exigida pelo DropdownButton).
    final value = selectedType == null
        ? null
        : availableTypes.firstWhere(
            (t) => t.id == selectedType!.id,
            orElse: () => selectedType!,
          );
    final items = {
      ...availableTypes,
      if (value != null && !availableTypes.any((t) => t.id == value.id)) value,
    }.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<ProjectTypes>(
          value: items.contains(value) ? value : null,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: CustomColors.midnight_slate),
          style: const TextStyle(
            color: CustomColors.midnight_slate,
            fontSize: 14,
          ),
          hint: Text(
            availableTypes.isEmpty ? 'Carregando tipos...' : 'Tipo de projeto',
            style: TextStyle(
              color: CustomColors.midnight_slate.withOpacity(0.45),
              fontSize: 14,
            ),
          ),
          items: items
              .map(
                (type) => DropdownMenuItem<ProjectTypes>(
                  value: type,
                  child: Text(type.name ?? '—'),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: 'Tipo de projeto',
            labelStyle: TextStyle(
              color: CustomColors.midnight_slate.withOpacity(0.45),
              fontSize: 14,
            ),
            floatingLabelStyle: const TextStyle(
              color: CustomColors.copper_spice,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Icon(
                Icons.category_outlined,
                color: CustomColors.midnight_slate.withOpacity(0.45),
                size: 18,
              ),
            ),
            filled: true,
            fillColor: CustomColors.vanilla_haze.withOpacity(0.05),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: CustomColors.soft_border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError
                    ? CustomColors.danger_red
                    : CustomColors.soft_border,
                width: hasError ? 1.5 : 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: CustomColors.copper_spice, width: 1.5),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              errorText!,
              style:
                  const TextStyle(color: CustomColors.danger_red, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}

class ProjectStatusField extends StatelessWidget {
  const ProjectStatusField({
    super.key,
    required this.active,
    required this.onChanged,
  });

  final bool active;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CustomColors.vanilla_haze.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CustomColors.soft_border),
      ),
      child: Row(
        children: [
          Icon(
            active
                ? Icons.check_circle_outline_rounded
                : Icons.pause_circle_outline_rounded,
            size: 18,
            color: active
                ? CustomColors.copper_spice
                : CustomColors.midnight_slate.withOpacity(0.45),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status do projeto',
                  style: TextStyle(
                    fontSize: 14,
                    color: CustomColors.midnight_slate,
                  ),
                ),
                Text(
                  active ? 'Ativo' : 'Inativo',
                  style: TextStyle(
                    fontSize: 12,
                    color: CustomColors.midnight_slate.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: active,
            onChanged: onChanged,
            activeColor: CustomColors.copper_spice,
          ),
        ],
      ),
    );
  }
}
