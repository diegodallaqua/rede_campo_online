import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/listing_tiles/research_area_tile.dart';
import 'package:rede_campo_online/core/utils/models/research_areas.dart';

import '../../../core/ui/theme/custom_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.midnight_slate,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ResearchAreaTile(researchArea: researchArea, green: false,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final researchArea = ResearchAreas.fromMap({
  'id': '1',
  'name': 'Sustentabilidade'
});
