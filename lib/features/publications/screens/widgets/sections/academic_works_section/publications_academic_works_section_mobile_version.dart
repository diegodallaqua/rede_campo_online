import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/academic_works/stores/academic_work_store.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../listing/academic_works/publications_academic_works_list_widget_mobile_version.dart';

class PublicationsAcademicWorksSectionMobileVersion extends StatefulWidget {
  final AcademicWorkStore academicWorkStore;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const PublicationsAcademicWorksSectionMobileVersion({
    super.key,
    required this.academicWorkStore,
    required this.searchController,
    required this.onSearch,
  });

  @override
  State<PublicationsAcademicWorksSectionMobileVersion> createState() =>
      _PublicationsAcademicWorksSectionMobileVersionState();
}

class _PublicationsAcademicWorksSectionMobileVersionState
    extends State<PublicationsAcademicWorksSectionMobileVersion> {
  int _maxDiscoveredPage = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Trabalhos Acadêmicos',
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
            hintText: 'Pesquisar trabalhos acadêmicos',
          ),
          const SizedBox(height: 16),
          PublicationsAcademicWorksListWidgetMobileVersion(
            academicWorkStore: widget.academicWorkStore,
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
