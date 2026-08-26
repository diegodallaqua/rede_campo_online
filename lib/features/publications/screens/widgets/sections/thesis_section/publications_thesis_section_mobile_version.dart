import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/thesis/stores/thesis_store.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../listing/thesis/publications_thesis_list_widget_mobile_version.dart';

class PublicationsThesisSectionMobileVersion extends StatefulWidget {
  final ThesisStore thesisStore;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const PublicationsThesisSectionMobileVersion({
    super.key,
    required this.thesisStore,
    required this.searchController,
    required this.onSearch,
  });

  @override
  State<PublicationsThesisSectionMobileVersion> createState() =>
      _PublicationsThesisSectionMobileVersionState();
}

class _PublicationsThesisSectionMobileVersionState
    extends State<PublicationsThesisSectionMobileVersion> {
  int _maxDiscoveredPage = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Dissertações',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 16),
          CustomSearchBar(
            controller: widget.searchController,
            onSubmitted: widget.onSearch,
            hintText: 'Pesquisar dissertações',
          ),
          const SizedBox(height: 16),
          PublicationsThesisListWidgetMobileVersion(
            thesisStore: widget.thesisStore,
            maxDiscoveredPage: _maxDiscoveredPage,
            onPageDiscovered: (newMax) {
              if (newMax > _maxDiscoveredPage) {
                setState(() => _maxDiscoveredPage = newMax);
              }
            },
          ),
        ],
      ),
    );
  }
}
