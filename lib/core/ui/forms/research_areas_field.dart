import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/forms/form_field_shell.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/research_areas/research_area_tile.dart';
import 'package:rede_campo_online/core/ui/widgets/dialogs/research_areas_dialog.dart';
import 'package:rede_campo_online/core/utils/models/research_areas.dart';

/// Campo de seleção múltipla de áreas de pesquisa, compartilhado pelos
/// formulários administrativos (notícias, projetos e publicações).
class ResearchAreasField extends StatelessWidget {
  const ResearchAreasField({
    super.key,
    required this.availableAreas,
    required this.selectedAreas,
    required this.onChanged,
  });

  final List<ResearchAreas> availableAreas;
  final List<ResearchAreas> selectedAreas;
  final void Function(List<ResearchAreas>) onChanged;

  Future<void> _openDialog(BuildContext context) async {
    final result = await ResearchAreasDialog.show(
      context: context,
      availableAreas: availableAreas,
      selectedAreas: selectedAreas,
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    return FormFieldShell(
      label: 'Áreas de Pesquisa',
      actionIcon: Icons.tune_rounded,
      actionLabel: selectedAreas.isEmpty ? 'Selecionar' : 'Editar',
      onAction: () => _openDialog(context),
      child: selectedAreas.isEmpty
          ? const FormFieldEmptyState(
              icon: Icons.category_outlined,
              message: 'Nenhuma área selecionada',
            )
          : FormFieldContentBox(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedAreas
                    .map((area) => ResearchAreaTile(
                          researchArea: area,
                          green: true,
                        ))
                    .toList(),
              ),
            ),
    );
  }
}
