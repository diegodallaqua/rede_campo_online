import 'package:flutter/material.dart';

import '../../../../core/ui/theme/custom_colors.dart';
import '../../../publications/stores/publications_store.dart';
import '../listing/publications_list_widget_mobile_version.dart';

class PublicationsSectionMobileVersion extends StatelessWidget {
  final PublicationsStore publicationsStore;

  const PublicationsSectionMobileVersion(
      {super.key, required this.publicationsStore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Publicações Recentes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: CustomColors.copper_spice,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PublicationsListWidgetMobileVersion(
              publicationsStore: publicationsStore,
              visibleCount: 3,
              totalCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}
