import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/research_areas/research_area_tile.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/utils/models/research_areas.dart';

class ResearchAreasDialog extends StatefulWidget {
  const ResearchAreasDialog({
    super.key,
    required this.availableAreas,
    this.selectedAreas = const [],
  });

  final List<ResearchAreas> availableAreas;
  final List<ResearchAreas> selectedAreas;

  /// Shows the dialog and returns the confirmed selection, or null if cancelled.
  static Future<List<ResearchAreas>?> show({
    required BuildContext context,
    required List<ResearchAreas> availableAreas,
    List<ResearchAreas> selectedAreas = const [],
  }) {
    return showDialog<List<ResearchAreas>>(
      context: context,
      builder: (_) => ResearchAreasDialog(
        availableAreas: availableAreas,
        selectedAreas: selectedAreas,
      ),
    );
  }

  @override
  State<ResearchAreasDialog> createState() => _ResearchAreasDialogState();
}

class _ResearchAreasDialogState extends State<ResearchAreasDialog> {
  late final Set<int> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = {
      for (final area in widget.selectedAreas)
        if (area.id != null) area.id!,
    };
  }

  void _toggle(ResearchAreas area) {
    if (area.id == null) return;
    setState(() {
      if (_selectedIds.contains(area.id)) {
        _selectedIds.remove(area.id);
      } else {
        _selectedIds.add(area.id!);
      }
    });
  }

  List<ResearchAreas> get _result => widget.availableAreas
      .where((a) => a.id != null && _selectedIds.contains(a.id))
      .toList();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Áreas de Pesquisa',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: CustomColors.midnight_slate,
          fontSize: 17,
        ),
      ),
      content: widget.availableAreas.isEmpty
          ? const Text(
              'Nenhuma área de pesquisa disponível.',
              style: TextStyle(color: Color(0xFF6B7280), fontSize: 14, height: 1.5),
            )
          : ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300, maxWidth: 400),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.availableAreas.map((area) {
                    final selected =
                        area.id != null && _selectedIds.contains(area.id);
                    return ResearchAreaTile(
                      researchArea: area,
                      green: selected,
                      onTap: () => _toggle(area),
                    );
                  }).toList(),
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Color(0xFF6B7280)),
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
          onPressed: () => Navigator.of(context).pop(_result),
          child: const Text(
            'Confirmar',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
