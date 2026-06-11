import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/research_areas/research_area_tile.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = {
      for (final area in widget.selectedAreas)
        if (area.id != null) area.id!,
    };
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query.trim().toLowerCase());
  }

  List<ResearchAreas> get _filteredAreas {
    if (_searchQuery.isEmpty) return widget.availableAreas;
    return widget.availableAreas
        .where((area) =>
            (area.name ?? '').toLowerCase().contains(_searchQuery))
        .toList();
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
                    hintText: 'Pesquisar áreas',
                    borderColor: const Color(0xFFE2E2DC),
                    textColor: CustomColors.midnight_slate,
                    hintColor: CustomColors.midnight_slate.withOpacity(0.45),
                    iconColor: CustomColors.midnight_slate.withOpacity(0.45),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _filteredAreas.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Nenhuma área encontrada',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CustomColors.midnight_slate
                                      .withOpacity(0.45),
                                ),
                              ),
                            )
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _filteredAreas.map((area) {
                                final selected = area.id != null &&
                                    _selectedIds.contains(area.id);
                                return ResearchAreaTile(
                                  researchArea: area,
                                  green: selected,
                                  onTap: () => _toggle(area),
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
