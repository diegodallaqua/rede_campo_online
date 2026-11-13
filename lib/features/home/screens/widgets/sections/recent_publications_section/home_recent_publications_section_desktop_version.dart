import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/router.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/ui/widgets/section_title.dart';
import '../../../../../publications/stores/publications_store.dart';
import '../../listing/recent_publications/recent_publications_list_widget_desktop_version.dart';

class HomeRecentPublicationsSectionDesktopVersion extends StatelessWidget {
  final PublicationsStore publicationsStore;

  const HomeRecentPublicationsSectionDesktopVersion(
      {super.key, required this.publicationsStore});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.only(top: 56, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: SectionTitle(
                  title: 'Publicações Recentes',
                  color: CustomColors.copper_spice,
                  trailing: SectionTitleAction(
                    color: CustomColors.pine_shadow,
                    onTap: () => context.go(AppRoutes.publications),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PublicationsListWidgetDesktopVersion(
                publicationsStore: publicationsStore,
                totalCount: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
