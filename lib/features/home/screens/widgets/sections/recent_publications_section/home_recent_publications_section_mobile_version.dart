import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/router.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/section_title.dart';
import '../../../../../publications/stores/publications_store.dart';
import '../../listing/recent_publications/recent_publications_list_widget_mobile_version.dart';

class HomeRecentPublicationsSectionMobileVersion extends StatelessWidget {
  final PublicationsStore publicationsStore;

  const HomeRecentPublicationsSectionMobileVersion(
      {super.key, required this.publicationsStore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SectionTitle.mobile(
              title: 'Publicações',
              color: CustomColors.copper_spice,
              trailing: SectionTitleAction(
                color: CustomColors.pine_shadow,
                onTap: () => context.go(AppRoutes.publications),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PublicationsListWidgetMobileVersion(
              publicationsStore: publicationsStore,
              visibleCount: 3,
            ),
          ),
        ],
      ),
    );
  }
}
