import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/forms/admin_input_decoration.dart';
import 'package:rede_campo_online/core/ui/forms/form_field_shell.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/features/admin/publications/models/publication_type.dart';

/// Dropdown do tipo de publicação. Na edição o tipo detectado fica travado
/// ([enabled] falso) e o valor atual é exibido como dica desabilitada.
class PublicationTypeField extends StatelessWidget {
  const PublicationTypeField({
    super.key,
    required this.selectedType,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
  });

  final PublicationType? selectedType;
  final void Function(PublicationType?) onChanged;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<PublicationType>(
          value: selectedType,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: CustomColors.midnight_slate,
          ),
          style: const TextStyle(
            color: CustomColors.midnight_slate,
            fontSize: 14,
          ),
          hint: Text(
            'Tipo de publicação',
            style: TextStyle(
              color: CustomColors.midnight_slate.withOpacity(0.45),
              fontSize: 14,
            ),
          ),
          items: PublicationType.values
              .map(
                (type) => DropdownMenuItem<PublicationType>(
                  value: type,
                  child: Text(type.label),
                ),
              )
              .toList(),
          onChanged: enabled ? onChanged : null,
          disabledHint: selectedType != null
              ? Text(
                  selectedType!.label,
                  style: const TextStyle(
                    color: CustomColors.midnight_slate,
                    fontSize: 14,
                  ),
                )
              : null,
          decoration: adminInputDecoration(
            label: 'Tipo de publicação',
            icon: Icons.category_outlined,
            highlightError: hasError,
            verticalPadding: 18,
          ),
        ),
        if (hasError) FieldErrorText(message: errorText!),
      ],
    );
  }
}
