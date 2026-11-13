import 'package:flutter/material.dart';
import 'package:rede_campo_online/core/ui/widgets/section_title.dart';
import 'package:rede_campo_online/core/ui/widgets/custom_search_bar.dart';
import 'package:rede_campo_online/features/academic_works/stores/academic_work_store.dart';
import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../listing/academic_works/publications_academic_works_list_widget_desktop_version.dart';

class PublicationsAcademicWorksSectionDesktopVersion extends StatefulWidget {
  final AcademicWorkStore academicWorkStore;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const PublicationsAcademicWorksSectionDesktopVersion({
    super.key,
    required this.academicWorkStore,
    required this.searchController,
    required this.onSearch,
  });

  @override
  State<PublicationsAcademicWorksSectionDesktopVersion> createState() =>
      _PublicationsAcademicWorksSectionDesktopVersionState();
}

class _PublicationsAcademicWorksSectionDesktopVersionState
    extends State<PublicationsAcademicWorksSectionDesktopVersion> {
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
                child: SectionTitle(
                  title: 'Trabalhos Acadêmicos',
                  color: CustomColors.fresh_sprout,
                  trailing: CustomSearchBar(
                    controller: widget.searchController,
                    onSubmitted: widget.onSearch,
                    hintText: 'Pesquisar trabalhos acadêmicos',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PublicationsAcademicWorksListWidgetDesktopVersion(
                academicWorkStore: widget.academicWorkStore,
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
