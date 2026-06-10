import 'package:flutter/material.dart';
import 'package:rede_campo_online/features/thesis/stores/thesis_store.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../listing/thesis/publications_thesis_list_widget_desktop_version.dart';

class PublicationsThesisSectionDesktopVersion extends StatefulWidget {
  final ThesisStore thesisStore;

  const PublicationsThesisSectionDesktopVersion({
    super.key,
    required this.thesisStore,
  });

  @override
  State<PublicationsThesisSectionDesktopVersion> createState() =>
      _PublicationsThesisSectionDesktopVersionState();
}

class _PublicationsThesisSectionDesktopVersionState
    extends State<PublicationsThesisSectionDesktopVersion> {
  int _maxDiscoveredPage = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dissertações',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: CustomColors.fresh_sprout,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 64,
                      height: 3,
                      decoration: BoxDecoration(
                        color: CustomColors.fresh_sprout,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PublicationsThesisListWidgetDesktopVersion(
                thesisStore: widget.thesisStore,
                maxDiscoveredPage: _maxDiscoveredPage,
                onPageDiscovered: (newMax) {
                  if (newMax != _maxDiscoveredPage) {
                    setState(() => _maxDiscoveredPage = newMax);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
