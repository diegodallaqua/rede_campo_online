import 'package:flutter/material.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../publications/stores/publications_store.dart';
import '../../listing/recent_publications_list_widget_desktop_version.dart';

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
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Publicações Recentes',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: CustomColors.copper_spice,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 64,
                          height: 3,
                          decoration: BoxDecoration(
                            color: CustomColors.copper_spice,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: navegar para a tela de publicações
                      },
                      icon: const Text(
                        'Ver todas',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.pine_shadow,
                        ),
                      ),
                      label: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: CustomColors.pine_shadow,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
