import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/research_areas/research_area_tile.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/research_areas_dialog.dart';
import 'package:rede_campo_online/core/utils/models/research_areas.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Áreas de Pesquisa',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: CustomColors.midnight_slate,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () => _openDialog(context),
              icon: const Icon(Icons.tune_rounded, size: 18),
              label: Text(selectedAreas.isEmpty ? 'Selecionar' : 'Editar'),
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
        if (selectedAreas.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: CustomColors.vanilla_haze.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E2DC)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 28,
                  color: CustomColors.midnight_slate.withOpacity(0.25),
                ),
                const SizedBox(height: 6),
                Text(
                  'Nenhuma área selecionada',
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CustomColors.vanilla_haze.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E2DC)),
            ),
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
      ],
    );
  }
}
